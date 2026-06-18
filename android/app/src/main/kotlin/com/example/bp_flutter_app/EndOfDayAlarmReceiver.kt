package com.example.bp_flutter_app

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import java.util.Calendar

/**
 * Fires at midnight local time each day.
 * Marks the day as "check pending" in SharedPreferences.
 * The actual compliance evaluation runs on next app launch
 * (FocusModeProvider._checkPendingReward) to avoid needing
 * Isar + Flutter engine in a background isolate.
 */
class EndOfDayAlarmReceiver : BroadcastReceiver() {

    companion object {
        private const val REQUEST_CODE = 7777
        private const val PREFS_NAME = "focus_mode_prefs"
        private const val KEY_PENDING_CHECK_DATE = "pending_check_date"

        fun schedule(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, EndOfDayAlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )

            // Schedule for midnight tonight
            val midnight = Calendar.getInstance().apply {
                add(Calendar.DAY_OF_YEAR, 1)
                set(Calendar.HOUR_OF_DAY, 0)
                set(Calendar.MINUTE, 0)
                set(Calendar.SECOND, 0)
                set(Calendar.MILLISECOND, 0)
            }

            // Use repeating alarm — fires daily at midnight
            alarmManager.setRepeating(
                AlarmManager.RTC_WAKEUP,
                midnight.timeInMillis,
                AlarmManager.INTERVAL_DAY,
                pendingIntent
            )
        }

        fun cancel(context: Context) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
            val intent = Intent(context, EndOfDayAlarmReceiver::class.java)
            val pendingIntent = PendingIntent.getBroadcast(
                context,
                REQUEST_CODE,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            alarmManager.cancel(pendingIntent)
        }
    }

    override fun onReceive(context: Context, intent: Intent?) {
        // Mark that a compliance check is pending for yesterday.
        // The Flutter app will pick this up on next launch.
        val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
        val cal = Calendar.getInstance()
        // The alarm fires at midnight, so "yesterday" is the day we just finished
        cal.add(Calendar.DAY_OF_YEAR, -1)
        val dateKey = String.format(
            "%04d-%02d-%02d",
            cal.get(Calendar.YEAR),
            cal.get(Calendar.MONTH) + 1,
            cal.get(Calendar.DAY_OF_MONTH)
        )
        prefs.edit().putString(KEY_PENDING_CHECK_DATE, dateKey).apply()

        // Re-schedule in case the repeating alarm drifts or was cancelled
        schedule(context)
    }
}
