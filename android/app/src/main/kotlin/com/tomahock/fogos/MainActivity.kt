package com.tomahock.fogos

import android.content.SharedPreferences
import androidx.core.content.edit
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "pt.fogos/live_activity"
    private val prefsName = "follow_fire_state"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result -> handle(call, result) }
    }

    private fun prefs(): SharedPreferences =
        getSharedPreferences(prefsName, MODE_PRIVATE)

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        @Suppress("UNCHECKED_CAST")
        val args = call.arguments as? Map<String, Any?>
        val fireId = args?.get("fireId") as? String
        if (call.method != "isActive" && fireId.isNullOrEmpty()) {
            result.error("bad_args", "fireId required", null)
            return
        }
        when (call.method) {
            "start" -> {
                FollowFireService.sendCommand(applicationContext, FollowFireService.ACTION_START, args!!)
                prefs().edit { putBoolean(fireId!!, true) }
                result.success(true)
            }
            "update" -> {
                // Only update if we started for that fire — avoids resurrecting a
                // dismissed notification.
                if (prefs().getBoolean(fireId!!, false)) {
                    FollowFireService.sendCommand(applicationContext, FollowFireService.ACTION_UPDATE, args!!)
                }
                result.success(null)
            }
            "stop" -> {
                FollowFireService.stop(applicationContext, fireId!!)
                prefs().edit { remove(fireId) }
                result.success(null)
            }
            "isActive" -> {
                val id = args?.get("fireId") as? String
                result.success(id != null && prefs().getBoolean(id, false))
            }
            else -> result.notImplemented()
        }
    }
}
