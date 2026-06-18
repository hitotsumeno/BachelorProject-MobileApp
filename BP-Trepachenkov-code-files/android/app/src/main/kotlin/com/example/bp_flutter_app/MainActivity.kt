package com.example.bp_flutter_app

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.bp_flutter_app/focus_mode"
    private var methodChannel: MethodChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel!!.setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInstalledApps" -> {
                        val apps = getInstalledApps()
                        result.success(apps)
                    }
                    "hasUsageStatsPermission" -> {
                        result.success(hasUsageStatsPermission())
                    }
                    "requestUsageStatsPermission" -> {
                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                        startActivity(intent)
                        result.success(null)
                    }
                    "hasOverlayPermission" -> {
                        result.success(Settings.canDrawOverlays(this))
                    }
                    "requestOverlayPermission" -> {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:$packageName")
                        )
                        startActivity(intent)
                        result.success(null)
                    }
                    "startBlockingService" -> {
                        val packages = call.argument<List<String>>("blockedPackages") ?: emptyList()
                        val scheduleJson = call.argument<String>("scheduleJson") ?: "[]"
                        startBlockingService(packages, scheduleJson)
                        result.success(null)
                    }
                    "stopBlockingService" -> {
                        stopBlockingService()
                        result.success(null)
                    }
                    "isBlockingServiceRunning" -> {
                        result.success(FocusBlockingService.isRunning)
                    }
                    "updateBlockedApps" -> {
                        val packages = call.argument<List<String>>("blockedPackages") ?: emptyList()
                        FocusBlockingService.updateBlockedPackages(this, packages)
                        result.success(null)
                    }
                    "scheduleEndOfDayAlarm" -> {
                        EndOfDayAlarmReceiver.schedule(this)
                        result.success(null)
                    }
                    "cancelEndOfDayAlarm" -> {
                        EndOfDayAlarmReceiver.cancel(this)
                        result.success(null)
                    }
                    "goToHomeScreen" -> {
                        val homeIntent = Intent(Intent.ACTION_MAIN).apply {
                            addCategory(Intent.CATEGORY_HOME)
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        startActivity(homeIntent)
                        result.success(null)
                    }
                    "consumeNativeBypasses" -> {
                        val prefs = getSharedPreferences("focus_mode", Context.MODE_PRIVATE)
                        val count = prefs.getInt("bypass_count_today", 0)
                        val lastPkg = prefs.getString("last_bypass_package", null)
                        // Clear after reading
                        prefs.edit()
                            .putInt("bypass_count_today", 0)
                            .remove("last_bypass_package")
                            .remove("last_bypass_time")
                            .apply()
                        result.success(mapOf(
                            "count" to count,
                            "lastPackage" to lastPkg
                        ))
                    }
                    "updateScheduleJson" -> {
                        val json = call.argument<String>("scheduleJson") ?: "[]"
                        FocusBlockingService.updateScheduleJson(json)
                        result.success(null)
                    }
                    "consumeNativeIntervals" -> {
                        val prefs = getSharedPreferences("focus_mode", Context.MODE_PRIVATE)
                        val usedCount = prefs.getInt("interval_used_count", 0)
                        val endTime = prefs.getLong("interval_end_time", 0)
                        val packages = prefs.getString("interval_packages", null)
                        // Clear after reading
                        prefs.edit()
                            .putInt("interval_used_count", 0)
                            .remove("interval_end_time")
                            .remove("interval_packages")
                            .apply()
                        result.success(mapOf(
                            "intervalsUsed" to usedCount,
                            "intervalEndTime" to if (endTime > 0) endTime else null,
                            "intervalPackages" to packages
                        ))
                    }
                    else -> result.notImplemented()
                }
            }

        // Handle block screen intent if the app was launched by the blocking service
        handleBlockScreenIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleBlockScreenIntent(intent)
    }

    private fun handleBlockScreenIntent(intent: Intent) {
        if (intent.getBooleanExtra("showBlockScreen", false)) {
            val packageName = intent.getStringExtra("blockedPackage") ?: ""
            val appName = try {
                val ai = packageManager.getApplicationInfo(packageName, 0)
                packageManager.getApplicationLabel(ai).toString()
            } catch (e: Exception) {
                packageName.split(".").last()
            }
            // Check if this package is in a strict group
            val isStrict = intent.getBooleanExtra("isStrict", false)

            methodChannel?.invokeMethod("showBlockScreen", mapOf(
                "packageName" to packageName,
                "appName" to appName,
                "isStrict" to isStrict
            ))

            // Clear the extra so it doesn't re-trigger
            intent.removeExtra("showBlockScreen")
        }
    }

    private fun getInstalledApps(): List<Map<String, Any?>> {
        val pm = packageManager
        val apps = mutableListOf<Map<String, Any?>>()

        val packages = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            pm.getInstalledApplications(PackageManager.ApplicationInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            pm.getInstalledApplications(0)
        }

        for (appInfo in packages) {
            // Only include apps with a launcher intent (user-visible apps)
            val launchIntent = pm.getLaunchIntentForPackage(appInfo.packageName)
            if (launchIntent != null && appInfo.packageName != packageName) {
                val iconBytes = try {
                    val drawable = pm.getApplicationIcon(appInfo)
                    val bitmap = if (drawable is BitmapDrawable) {
                        drawable.bitmap
                    } else {
                        val bmp = Bitmap.createBitmap(
                            drawable.intrinsicWidth.coerceAtLeast(1),
                            drawable.intrinsicHeight.coerceAtLeast(1),
                            Bitmap.Config.ARGB_8888
                        )
                        val canvas = Canvas(bmp)
                        drawable.setBounds(0, 0, canvas.width, canvas.height)
                        drawable.draw(canvas)
                        bmp
                    }
                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
                    stream.toByteArray()
                } catch (e: Exception) {
                    null
                }

                apps.add(
                    mapOf(
                        "packageName" to appInfo.packageName,
                        "appName" to pm.getApplicationLabel(appInfo).toString(),
                        "icon" to iconBytes
                    )
                )
            }
        }
        return apps
    }

    private fun hasUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun startBlockingService(packages: List<String>, scheduleJson: String) {
        val intent = Intent(this, FocusBlockingService::class.java).apply {
            putStringArrayListExtra("blockedPackages", ArrayList(packages))
            putExtra("scheduleJson", scheduleJson)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopBlockingService() {
        val intent = Intent(this, FocusBlockingService::class.java)
        stopService(intent)
    }
}
