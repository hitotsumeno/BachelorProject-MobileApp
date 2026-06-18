package com.example.bp_flutter_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.graphics.PixelFormat
import android.graphics.Typeface
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.provider.Settings
import android.text.Spannable
import android.text.SpannableString
import android.text.style.ForegroundColorSpan
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import androidx.core.app.NotificationCompat
import org.json.JSONArray
import org.json.JSONObject
import java.util.Calendar

class FocusBlockingService : Service() {

    companion object {
        const val CHANNEL_ID = "focus_blocking_channel"
        const val NOTIFICATION_ID = 9001
        const val POLL_INTERVAL_MS = 1500L
        const val BYPASS_DELAY_MS = 5000L

        @Volatile
        var isRunning = false
            private set

        private var blockedPackages = mutableSetOf<String>()
        private var scheduleJson = "[]"

        fun updateBlockedPackages(context: Context, packages: List<String>) {
            blockedPackages.clear()
            blockedPackages.addAll(packages)
        }

        fun updateScheduleJson(json: String) {
            scheduleJson = json
        }
    }

    private val handler = Handler(Looper.getMainLooper())
    private lateinit var pollRunnable: Runnable
    private var lastBlockedPackage: String? = null
    private var lastBlockTime: Long = 0

    private var windowManager: WindowManager? = null
    private var overlayView: View? = null

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        isRunning = true
        windowManager = getSystemService(WINDOW_SERVICE) as WindowManager
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        intent?.let {
            val packages = it.getStringArrayListExtra("blockedPackages")
            if (packages != null) {
                blockedPackages.clear()
                blockedPackages.addAll(packages)
            }
            val json = it.getStringExtra("scheduleJson")
            if (json != null) {
                scheduleJson = json
            }
        }

        val notification = buildNotification()
        startForeground(NOTIFICATION_ID, notification)

        startPolling()

        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        isRunning = false
        handler.removeCallbacksAndMessages(null)
        removeOverlay()
        super.onDestroy()
    }

    private fun startPolling() {
        pollRunnable = object : Runnable {
            override fun run() {
                checkForegroundApp()
                handler.postDelayed(this, POLL_INTERVAL_MS)
            }
        }
        handler.post(pollRunnable)
    }

    private fun checkForegroundApp() {
        val foregroundPackage = getForegroundPackage() ?: return

        // If overlay is showing and user navigated away from the blocked app, dismiss it
        if (overlayView != null && foregroundPackage != lastBlockedPackage) {
            removeOverlay()
            return
        }

        // Skip if overlay is already showing for this package
        if (overlayView != null && foregroundPackage == lastBlockedPackage) {
            return
        }

        // Skip if we just blocked this package (debounce to avoid rapid re-trigger)
        val now = System.currentTimeMillis()
        if (foregroundPackage == lastBlockedPackage && now - lastBlockTime < 3000) {
            return
        }

        if (foregroundPackage in blockedPackages && isInActiveWindow()) {
            // An active interval grants the user free access — skip blocking until it expires
            if (isInActiveInterval(foregroundPackage)) return

            lastBlockedPackage = foregroundPackage
            lastBlockTime = now
            val strict = isPackageStrict(foregroundPackage)
            val appName = getAppName(foregroundPackage)
            showOverlay(appName, foregroundPackage, strict)
        }
    }

    private fun getForegroundPackage(): String? {
        val usm = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            ?: return null

        val now = System.currentTimeMillis()
        val stats = usm.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY,
            now - 10_000,
            now
        )

        if (stats.isNullOrEmpty()) return null

        return stats.maxByOrNull { it.lastTimeUsed }?.packageName
    }

    private fun getAppName(packageName: String): String {
        return try {
            val ai = packageManager.getApplicationInfo(packageName, 0)
            packageManager.getApplicationLabel(ai).toString()
        } catch (e: Exception) {
            packageName.split(".").last()
        }
    }

    private fun isInActiveWindow(): Boolean {
        try {
            val groups = JSONArray(scheduleJson)
            val cal = Calendar.getInstance()
            val calDay = cal.get(Calendar.DAY_OF_WEEK)
            val isoDay = if (calDay == Calendar.SUNDAY) 7 else calDay - 1
            val currentMinutes = cal.get(Calendar.HOUR_OF_DAY) * 60 + cal.get(Calendar.MINUTE)

            for (i in 0 until groups.length()) {
                val group = groups.getJSONObject(i)
                val days = group.getJSONArray("activeDays")
                var dayMatch = false
                for (d in 0 until days.length()) {
                    if (days.getInt(d) == isoDay) {
                        dayMatch = true
                        break
                    }
                }
                if (!dayMatch) continue

                val windows = group.getJSONArray("windows")
                for (w in 0 until windows.length()) {
                    val win = windows.getJSONObject(w)
                    val start = win.getInt("sh") * 60 + win.getInt("sm")
                    val end = win.getInt("eh") * 60 + win.getInt("em")

                    val inWindow = if (end > start) {
                        currentMinutes in start until end
                    } else {
                        currentMinutes >= start || currentMinutes < end
                    }
                    if (inWindow) return true
                }
            }
        } catch (e: Exception) {
            // If schedule parsing fails, don't block
        }
        return false
    }

    private fun isPackageStrict(packageName: String): Boolean {
        try {
            val groups = JSONArray(scheduleJson)
            for (i in 0 until groups.length()) {
                val group = groups.getJSONObject(i)
                if (group.optBoolean("isStrict", false)) {
                    val packages = group.getJSONArray("packages")
                    for (p in 0 until packages.length()) {
                        if (packages.getString(p) == packageName) return true
                    }
                }
            }
        } catch (_: Exception) {}
        return false
    }

    private fun findGroupForPackage(packageName: String, isStrict: Boolean): JSONObject? {
        try {
            val groups = JSONArray(scheduleJson)
            for (i in 0 until groups.length()) {
                val group = groups.getJSONObject(i)
                if (group.optBoolean("isStrict", false) != isStrict) continue
                val packages = group.getJSONArray("packages")
                for (p in 0 until packages.length()) {
                    if (packages.getString(p) == packageName) return group
                }
            }
        } catch (_: Exception) {}
        return null
    }

    private fun buildPipSpannable(remaining: Int, total: Int): CharSequence {
        val sb = StringBuilder()
        val filledRanges = mutableListOf<Pair<Int, Int>>()
        val unfilledRanges = mutableListOf<Pair<Int, Int>>()
        for (i in 0 until total) {
            if (i > 0) sb.append("  ")
            val start = sb.length
            sb.append(if (i < remaining) "●" else "○")
            val end = sb.length
            if (i < remaining) filledRanges.add(start to end) else unfilledRanges.add(start to end)
        }
        val spannable = SpannableString(sb)
        for ((s, e) in filledRanges) {
            spannable.setSpan(
                ForegroundColorSpan(Color.parseColor("#FFB347")),
                s, e, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
            )
        }
        for ((s, e) in unfilledRanges) {
            spannable.setSpan(
                ForegroundColorSpan(Color.parseColor("#88FFFFFF")),
                s, e, Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
            )
        }
        return spannable
    }

    // ── Overlay ──

    private fun showOverlay(appName: String, packageName: String, isStrict: Boolean) {
        if (!Settings.canDrawOverlays(this)) return

        removeOverlay() // clean up any existing overlay

        val dp = { value: Int ->
            TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_DIP,
                value.toFloat(),
                resources.displayMetrics
            ).toInt()
        }

        // Root layout
        val layout = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setBackgroundColor(Color.BLACK)
            setPadding(dp(32), dp(48), dp(32), dp(48))
        }

        // Icon placeholder (pause icon via text)
        val iconText = TextView(this).apply {
            text = "⏸"
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 64f)
            setTextColor(Color.parseColor("#88FFFFFF"))
            gravity = Gravity.CENTER
        }
        layout.addView(iconText)

        // Title
        val title = TextView(this).apply {
            text = "Take a breath."
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 28f)
            setTextColor(Color.WHITE)
            typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
            gravity = Gravity.CENTER
            setPadding(0, dp(24), 0, 0)
        }
        layout.addView(title)

        // Streak + interval pip indicators
        val group = findGroupForPackage(packageName, isStrict)
        if (group != null) {
            val streak = group.optInt("streak", 0)
            val intervalsPerDay = group.optInt("intervalsPerDay", 0)
            val intervalsRemaining = group.optInt("intervalsRemaining", 0)
            val showPips = !isStrict && intervalsPerDay > 0

            val infoRow = LinearLayout(this).apply {
                orientation = LinearLayout.HORIZONTAL
                gravity = Gravity.CENTER
                val lp = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                )
                lp.topMargin = dp(16)
                layoutParams = lp
            }

            val streakText = TextView(this).apply {
                text = "🔥 $streak"
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
                setTextColor(Color.parseColor("#FFB347"))
                gravity = Gravity.CENTER
            }
            infoRow.addView(streakText)

            if (showPips) {
                val pipText = TextView(this).apply {
                    text = buildPipSpannable(intervalsRemaining, intervalsPerDay)
                    setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
                    gravity = Gravity.CENTER
                    val pipLp = LinearLayout.LayoutParams(
                        LinearLayout.LayoutParams.WRAP_CONTENT,
                        LinearLayout.LayoutParams.WRAP_CONTENT
                    )
                    pipLp.leftMargin = dp(20)
                    layoutParams = pipLp
                }
                infoRow.addView(pipText)
            }

            layout.addView(infoRow)
        }

        // Blocked app name
        val subtitle = TextView(this).apply {
            text = "$appName is blocked right now."
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 16f)
            setTextColor(Color.parseColor("#B3FFFFFF"))
            gravity = Gravity.CENTER
            setPadding(0, dp(16), 0, 0)
        }
        layout.addView(subtitle)

        // Motivational text
        val motivation = TextView(this).apply {
            text = "You set this limit to help you focus.\nIs this really how you want to spend your time?"
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 14f)
            setTextColor(Color.parseColor("#61FFFFFF"))
            gravity = Gravity.CENTER
            setPadding(0, dp(8), 0, 0)
        }
        layout.addView(motivation)

        // Go Back button
        val goBackBtn = Button(this).apply {
            text = "Go Back"
            setTextColor(Color.parseColor("#B3FFFFFF"))
            setBackgroundColor(Color.TRANSPARENT)
            setPadding(dp(24), dp(14), dp(24), dp(14))
            val lp = LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
            )
            lp.topMargin = dp(48)
            layoutParams = lp
            setOnClickListener {
                removeOverlay()
                goToHomeScreen()
            }
        }
        layout.addView(goBackBtn)

        // Strict mode label or bypass button
        if (isStrict) {
            val strictLabel = TextView(this).apply {
                text = "Strict mode — no bypass available."
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f)
                setTextColor(Color.parseColor("#FFFF5252"))
                gravity = Gravity.CENTER
                setPadding(0, dp(24), 0, 0)
            }
            layout.addView(strictLabel)
        } else {
            val intervalsLeft = group?.optInt("intervalsRemaining", 0) ?: 0
            val intervalMinutes = group?.optInt("intervalMinutes", 0) ?: 0
            val canUseInterval = group != null && intervalsLeft > 0 && intervalMinutes > 0

            val bypassBtn = Button(this).apply {
                text = if (canUseInterval) {
                    "Open anyway (uses 1 interval • ${intervalMinutes}m)"
                } else {
                    "Open anyway (breaks your streak)"
                }
                setTextColor(Color.parseColor("#3DFFFFFF"))
                setBackgroundColor(Color.TRANSPARENT)
                setTextSize(TypedValue.COMPLEX_UNIT_SP, 12f)
                visibility = View.INVISIBLE
                val lp = LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
                )
                lp.topMargin = dp(16)
                lp.gravity = Gravity.CENTER
                layoutParams = lp
                setOnClickListener {
                    if (canUseInterval && group != null) {
                        startInterval(group)
                    } else {
                        recordBypassInPrefs(packageName)
                    }
                    removeOverlay()
                }
            }
            layout.addView(bypassBtn)

            // Show bypass after delay
            handler.postDelayed({
                if (overlayView != null) {
                    bypassBtn.visibility = View.VISIBLE
                }
            }, BYPASS_DELAY_MS)
        }

        // Window params
        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
            WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                    WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )

        overlayView = layout
        windowManager?.addView(layout, params)
    }

    private fun removeOverlay() {
        overlayView?.let {
            try {
                windowManager?.removeView(it)
            } catch (_: Exception) {}
            overlayView = null
        }
    }

    private fun goToHomeScreen() {
        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(homeIntent)
    }

    private fun recordBypassInPrefs(packageName: String) {
        // Store bypass event in SharedPreferences so Flutter can pick it up on next launch
        val prefs = getSharedPreferences("focus_mode", Context.MODE_PRIVATE)
        val count = prefs.getInt("bypass_count_today", 0)
        prefs.edit()
            .putInt("bypass_count_today", count + 1)
            .putString("last_bypass_package", packageName)
            .putLong("last_bypass_time", System.currentTimeMillis())
            .apply()
    }

    private fun isInActiveInterval(packageName: String): Boolean {
        val prefs = getSharedPreferences("focus_mode", Context.MODE_PRIVATE)
        val endTime = prefs.getLong("interval_end_time", 0)
        if (endTime <= System.currentTimeMillis()) return false
        val packages = prefs.getString("interval_packages", null) ?: return false
        return packages.split(",").contains(packageName)
    }

    private fun startInterval(group: JSONObject) {
        val intervalMinutes = group.optInt("intervalMinutes", 5).coerceAtLeast(1)
        val packagesArr = group.optJSONArray("packages") ?: return
        val packageList = mutableListOf<String>()
        for (p in 0 until packagesArr.length()) packageList.add(packagesArr.getString(p))

        val prefs = getSharedPreferences("focus_mode", Context.MODE_PRIVATE)
        val currentUsed = prefs.getInt("interval_used_count", 0)
        val endTime = System.currentTimeMillis() + intervalMinutes * 60_000L

        prefs.edit()
            .putLong("interval_end_time", endTime)
            .putString("interval_packages", packageList.joinToString(","))
            .putInt("interval_used_count", currentUsed + 1)
            .apply()

        // Decrement intervalsRemaining in the in-memory scheduleJson so the next overlay
        // shows the updated pip count without waiting for Flutter to refresh.
        decrementIntervalsRemaining(group.optInt("id", -1))
    }

    private fun decrementIntervalsRemaining(groupId: Int) {
        if (groupId < 0) return
        try {
            val groups = JSONArray(scheduleJson)
            for (i in 0 until groups.length()) {
                val g = groups.getJSONObject(i)
                if (g.optInt("id", -1) == groupId) {
                    val remaining = g.optInt("intervalsRemaining", 0)
                    if (remaining > 0) g.put("intervalsRemaining", remaining - 1)
                    break
                }
            }
            scheduleJson = groups.toString()
        } catch (_: Exception) {}
    }

    // ── Notification ──

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Focus Mode",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Focus Mode is actively blocking distracting apps"
            }
            val nm = getSystemService(NotificationManager::class.java)
            nm.createNotificationChannel(channel)
        }
    }

    private fun buildNotification(): Notification {
        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Focus Mode Active")
            .setContentText("Blocking ${blockedPackages.size} apps")
            .setSmallIcon(android.R.drawable.ic_lock_idle_lock)
            .setOngoing(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
    }
}
