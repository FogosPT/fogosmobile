package com.tomahock.fogos

import android.content.Context
import android.hardware.GeomagneticField
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.os.Handler
import android.os.Looper
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlin.math.atan2
import kotlin.math.sqrt

/**
 * Android counterpart to the iOS OrientationBridge. Uses the fused
 * TYPE_ROTATION_VECTOR sensor (accel + gyro + mag under a Kalman filter)
 * and reads the rotation matrix directly instead of computing tilt
 * compensation in Dart from raw magnetometer + accelerometer.
 *
 * Emits { headingDeg, pitchDeg, accuracy, isTrueNorth } on the
 * `pt.fogos/orientation` MethodChannel. When the Flutter side hands us
 * the current GPS coordinates via `setLocation`, we add the local
 * declination from GeomagneticField so the reported heading is true
 * north (matching iOS `.xTrueNorthZVertical`).
 */
class OrientationBridge private constructor(context: Context) : SensorEventListener {

    private val sensorManager: SensorManager =
        context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
    private val rotationSensor: Sensor? =
        sensorManager.getDefaultSensor(Sensor.TYPE_ROTATION_VECTOR)
    private val mainHandler = Handler(Looper.getMainLooper())

    private var channel: MethodChannel? = null
    private var listening = false

    // Latest GPS position, used to compute declination for true-north.
    private var lastLat: Double? = null
    private var lastLng: Double? = null
    private var lastAlt: Double? = null

    // Reused buffers to avoid allocations in the hot path.
    private val rotationMatrix = FloatArray(9)
    private val remappedMatrix = FloatArray(9)

    fun register(messenger: BinaryMessenger) {
        val ch = MethodChannel(messenger, "pt.fogos/orientation")
        channel = ch
        ch.setMethodCallHandler { call, result -> handle(call, result) }
    }

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "start" -> result.success(start())
            "stop" -> { stop(); result.success(true) }
            "isAvailable" -> result.success(rotationSensor != null)
            "setLocation" -> {
                lastLat = call.argument<Double>("lat")
                lastLng = call.argument<Double>("lng")
                lastAlt = call.argument<Double>("alt")
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun start(): Boolean {
        val sensor = rotationSensor ?: return false
        if (listening) return true
        listening = sensorManager.registerListener(
            this, sensor, SensorManager.SENSOR_DELAY_UI
        )
        return listening
    }

    private fun stop() {
        if (!listening) return
        sensorManager.unregisterListener(this)
        listening = false
    }

    override fun onSensorChanged(event: SensorEvent) {
        if (event.sensor.type != Sensor.TYPE_ROTATION_VECTOR) return
        SensorManager.getRotationMatrixFromVector(rotationMatrix, event.values)
        // rotationMatrix maps device coords → world (X=East, Y=North,
        // Z=Up). The Flutter camera axis is device -Z (back of the
        // phone). To keep the maths readable, remap so the sensor matrix
        // stays consistent regardless of the physical orientation the
        // user is holding the phone in — this compensates for portrait /
        // landscape rotation of the display.
        SensorManager.remapCoordinateSystem(
            rotationMatrix,
            SensorManager.AXIS_X,
            SensorManager.AXIS_Y,
            remappedMatrix,
        )
        // Camera axis in device coords: (0, 0, -1). Apply matrix:
        //   world = R * device
        //   cam_world = (-R[2], -R[5], -R[8])
        // World: X = East, Y = North, Z = Up.
        val east = -remappedMatrix[2]
        val north = -remappedMatrix[5]
        val up = -remappedMatrix[8]
        var magneticAzimuth = Math.toDegrees(atan2(east, north).toDouble())
        if (magneticAzimuth < 0) magneticAzimuth += 360.0

        val declination = declinationDegrees()
        var heading = magneticAzimuth + declination
        heading = ((heading % 360.0) + 360.0) % 360.0

        val horiz = sqrt((east * east + north * north).toDouble())
        val pitch = Math.toDegrees(atan2(up.toDouble(), horiz))

        // getRotationMatrixFromVector occasionally yields a degenerate
        // matrix during sensor warm-up; skip those samples instead of
        // shipping NaN to Flutter (where .floor() / .round() throw).
        if (heading.isNaN() || heading.isInfinite() ||
            pitch.isNaN() || pitch.isInfinite()) return

        val accuracyLabel = when (event.accuracy) {
            SensorManager.SENSOR_STATUS_ACCURACY_HIGH -> "high"
            SensorManager.SENSOR_STATUS_ACCURACY_MEDIUM -> "medium"
            SensorManager.SENSOR_STATUS_ACCURACY_LOW -> "low"
            SensorManager.SENSOR_STATUS_UNRELIABLE -> "uncalibrated"
            else -> "unknown"
        }

        val args = mapOf(
            "headingDeg" to heading,
            "pitchDeg" to pitch,
            "accuracy" to accuracyLabel,
            "isTrueNorth" to (declination != 0.0f.toDouble()),
        )
        mainHandler.post { channel?.invokeMethod("orientation", args) }
    }

    private fun declinationDegrees(): Double {
        val lat = lastLat ?: return 0.0
        val lng = lastLng ?: return 0.0
        val alt = lastAlt?.toFloat() ?: 0f
        return GeomagneticField(
            lat.toFloat(), lng.toFloat(), alt, System.currentTimeMillis()
        ).declination.toDouble()
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Accuracy piggy-backs on each sensor event above; nothing to do
        // here beyond receiving the callback.
    }

    companion object {
        @Volatile
        private var instance: OrientationBridge? = null

        fun get(context: Context): OrientationBridge =
            instance ?: synchronized(this) {
                instance ?: OrientationBridge(context.applicationContext).also { instance = it }
            }
    }
}
