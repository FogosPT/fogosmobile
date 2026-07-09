package com.tomahock.fogos

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Color
import android.net.Uri
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

/// Ongoing notification per followed fire — the Android counterpart to
/// iOS Live Activities. Notifications stay visible until the fire is
/// dismissed or resolved, keeping meios/status visible on the lock screen
/// and shade like a live sports score.
class FollowFireService : Service() {

    private val activeFires = mutableMapOf<String, Notification>()

    override fun onCreate() {
        super.onCreate()
        ensureChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val action = intent?.action
        val fireId = intent?.getStringExtra(EXTRA_FIRE_ID)
        if (action == null || fireId.isNullOrEmpty()) {
            return START_NOT_STICKY
        }
        when (action) {
            ACTION_START, ACTION_UPDATE -> upsert(fireId, intent)
            ACTION_STOP -> remove(fireId)
        }
        return START_STICKY
    }

    private fun upsert(fireId: String, intent: Intent) {
        val notification = buildNotification(fireId, intent)
        val id = fireId.hashCode()
        val wasEmpty = activeFires.isEmpty()
        activeFires[fireId] = notification
        if (wasEmpty) {
            // First fire followed → become a foreground service.
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                startForeground(id, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC)
            } else {
                startForeground(id, notification)
            }
        } else {
            // Additional fires → post as normal notifications on the same channel.
            NotificationManagerCompat.from(this).notify(id, notification)
        }
    }

    private fun remove(fireId: String) {
        activeFires.remove(fireId)
        NotificationManagerCompat.from(this).cancel(fireId.hashCode())
        if (activeFires.isEmpty()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                stopForeground(STOP_FOREGROUND_REMOVE)
            } else {
                @Suppress("DEPRECATION")
                stopForeground(true)
            }
            stopSelf()
        }
    }

    private fun buildNotification(fireId: String, intent: Intent): Notification {
        val title = intent.getStringExtra(EXTRA_TITLE) ?: "Incêndio"
        val location = intent.getStringExtra(EXTRA_LOCATION) ?: ""
        val statusText = intent.getStringExtra(EXTRA_STATUS_TEXT) ?: ""
        val statusColor = intent.getStringExtra(EXTRA_STATUS_COLOR) ?: "#FF512F"
        val human = intent.getIntExtra(EXTRA_HUMAN, 0)
        val terrain = intent.getIntExtra(EXTRA_TERRAIN, 0)
        val aerial = intent.getIntExtra(EXTRA_AERIAL, 0)
        val isFire = intent.getBooleanExtra(EXTRA_IS_FIRE, true)

        val body = buildString {
            if (statusText.isNotEmpty()) append(statusText)
            if (isNotEmpty()) append(" · ")
            append("👥 $human")
            append("  🚗 $terrain")
            append("  ✈️ $aerial")
        }

        val bigText = NotificationCompat.BigTextStyle()
            .bigText(buildString {
                if (location.isNotEmpty()) appendLine(location)
                if (statusText.isNotEmpty()) appendLine(statusText)
                append("Operacionais: $human")
                append("   Viaturas: $terrain")
                append("   Aéreos: $aerial")
            })

        val icon = if (isFire) R.mipmap.ic_launcher else R.mipmap.ic_launcher

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(icon)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(bigText)
            .setColor(parseHexColor(statusColor))
            .setColorized(true)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(buildOpenAppIntent(fireId))
            .addAction(0, "Deixar de seguir", buildStopIntent(fireId))
            .build()
    }

    private fun buildOpenAppIntent(fireId: String): PendingIntent {
        val intent = Intent(this, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            data = Uri.parse("fogos://follow?fireId=$fireId")
        }
        return PendingIntent.getActivity(
            this,
            fireId.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun buildStopIntent(fireId: String): PendingIntent {
        val intent = Intent(this, FollowFireService::class.java).apply {
            action = ACTION_STOP
            putExtra(EXTRA_FIRE_ID, fireId)
        }
        return PendingIntent.getService(
            this,
            fireId.hashCode() xor 0x100,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun ensureChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (manager.getNotificationChannel(CHANNEL_ID) != null) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Fogos seguidos",
            NotificationManager.IMPORTANCE_LOW,
        ).apply {
            description = "Notificação persistente para incêndios em curso que estás a seguir."
            setShowBadge(false)
        }
        manager.createNotificationChannel(channel)
    }

    private fun parseHexColor(hex: String): Int {
        val cleaned = hex.removePrefix("#")
        if (cleaned.length != 6) return Color.parseColor("#FF512F")
        return try {
            Color.parseColor("#$cleaned")
        } catch (_: IllegalArgumentException) {
            Color.parseColor("#FF512F")
        }
    }

    override fun onBind(intent: Intent?): IBinder? = null

    companion object {
        const val ACTION_START = "pt.fogos.follow.START"
        const val ACTION_UPDATE = "pt.fogos.follow.UPDATE"
        const val ACTION_STOP = "pt.fogos.follow.STOP"

        const val EXTRA_FIRE_ID = "fireId"
        const val EXTRA_TITLE = "title"
        const val EXTRA_LOCATION = "location"
        const val EXTRA_STATUS_TEXT = "statusText"
        const val EXTRA_STATUS_COLOR = "statusColor"
        const val EXTRA_HUMAN = "human"
        const val EXTRA_TERRAIN = "terrain"
        const val EXTRA_AERIAL = "aerial"
        const val EXTRA_IS_FIRE = "isFire"

        private const val CHANNEL_ID = "fogos_following"

        fun sendCommand(context: Context, action: String, extras: Map<String, Any?>) {
            val intent = Intent(context, FollowFireService::class.java).apply {
                this.action = action
                extras.forEach { (key, value) ->
                    when (value) {
                        is String -> putExtra(key, value)
                        is Int -> putExtra(key, value)
                        is Long -> putExtra(key, value)
                        is Double -> putExtra(key, value)
                        is Boolean -> putExtra(key, value)
                        null -> { /* skip */ }
                    }
                }
            }
            androidx.core.content.ContextCompat.startForegroundService(context, intent)
        }

        fun stop(context: Context, fireId: String) {
            val intent = Intent(context, FollowFireService::class.java).apply {
                this.action = ACTION_STOP
                putExtra(EXTRA_FIRE_ID, fireId)
            }
            context.startService(intent)
        }
    }
}
