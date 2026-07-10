package com.tomahock.fogos

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat

/// Persistent ongoing notification per followed fire — Android counterpart
/// to iOS Live Activities. Posted directly via NotificationManagerCompat
/// so no foreground service is needed: the notification survives on its
/// own until explicitly cancelled by the user or the app.
object FollowFireNotifier {
    private const val CHANNEL_ID = "fogos_following"

    fun notify(context: Context, args: Map<String, Any?>) {
        ensureChannel(context)
        val fireId = args["fireId"] as? String ?: return
        val notification = build(context, fireId, args)
        NotificationManagerCompat.from(context).notify(fireId.hashCode(), notification)
    }

    fun cancel(context: Context, fireId: String) {
        NotificationManagerCompat.from(context).cancel(fireId.hashCode())
    }

    private fun build(context: Context, fireId: String, args: Map<String, Any?>): android.app.Notification {
        val title = args["title"] as? String ?: "Incêndio"
        val location = args["location"] as? String ?: ""
        val statusText = args["statusText"] as? String ?: ""
        val statusColor = args["statusColor"] as? String ?: "#FF512F"
        val human = (args["human"] as? Number)?.toInt() ?: 0
        val terrain = (args["terrain"] as? Number)?.toInt() ?: 0
        val aerial = (args["aerial"] as? Number)?.toInt() ?: 0
        val isFire = args["isFire"] as? Boolean ?: true

        val body = buildString {
            if (statusText.isNotEmpty()) append(statusText).append(" · ")
            append("👥 $human   🚗 $terrain   ✈️ $aerial")
        }

        val bigText = NotificationCompat.BigTextStyle().bigText(buildString {
            if (location.isNotEmpty()) appendLine(location)
            if (statusText.isNotEmpty()) appendLine(statusText)
            append("Operacionais: $human   Viaturas: $terrain   Aéreos: $aerial")
        })

        val icon = if (isFire) R.mipmap.ic_launcher else R.mipmap.ic_launcher

        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(icon)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(bigText)
            .setColor(parseHexColor(statusColor))
            .setColorized(true)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setContentIntent(buildOpenAppIntent(context, fireId))
            .addAction(0, "Deixar de seguir", buildStopIntent(context, fireId))
            .build()
    }

    private fun buildOpenAppIntent(context: Context, fireId: String): PendingIntent {
        val intent = Intent(context, MainActivity::class.java).apply {
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
            data = Uri.parse("fogos://follow?fireId=$fireId")
        }
        return PendingIntent.getActivity(
            context,
            fireId.hashCode(),
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun buildStopIntent(context: Context, fireId: String): PendingIntent {
        val intent = Intent(context, FollowFireStopReceiver::class.java).apply {
            action = FollowFireStopReceiver.ACTION_STOP
            putExtra(FollowFireStopReceiver.EXTRA_FIRE_ID, fireId)
        }
        return PendingIntent.getBroadcast(
            context,
            fireId.hashCode() xor 0x100,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun ensureChannel(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val manager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
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
}
