package com.tomahock.fogos

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import androidx.core.content.edit

/// Receiver for the "Deixar de seguir" action on ongoing follow notifications.
/// Cancels the notification and clears the persisted flag so the Dart side
/// stops sending updates for that fire.
class FollowFireStopReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != ACTION_STOP) return
        val fireId = intent.getStringExtra(EXTRA_FIRE_ID) ?: return
        FollowFireNotifier.cancel(context, fireId)
        context.getSharedPreferences("follow_fire_state", Context.MODE_PRIVATE)
            .edit { remove(fireId) }
    }

    companion object {
        const val ACTION_STOP = "pt.fogos.follow.STOP"
        const val EXTRA_FIRE_ID = "fireId"
    }
}
