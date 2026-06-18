import 'package:flutter/services.dart';

/// Platform channel bridge for Focus Mode native features.
/// Android only — blocking service, permissions, foreground app detection.
class FocusModeService {
  static const _channel = MethodChannel('com.example.bp_flutter_app/focus_mode');

  // ── Installed apps ──

  /// Returns list of installed launchable apps.
  /// Each map: { packageName: String, appName: String, icon: Uint8List? }
  static Future<List<Map<String, dynamic>>> getInstalledApps() async {
    final List<dynamic> result =
        await _channel.invokeMethod('getInstalledApps');
    return result.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      if (map['icon'] != null) {
        map['icon'] = Uint8List.fromList(List<int>.from(map['icon'] as List));
      }
      return map;
    }).toList();
  }

  // ── Permissions ──

  static Future<bool> hasUsageStatsPermission() async {
    return await _channel.invokeMethod<bool>('hasUsageStatsPermission') ??
        false;
  }

  static Future<void> requestUsageStatsPermission() async {
    await _channel.invokeMethod('requestUsageStatsPermission');
  }

  static Future<bool> hasOverlayPermission() async {
    return await _channel.invokeMethod<bool>('hasOverlayPermission') ?? false;
  }

  static Future<void> requestOverlayPermission() async {
    await _channel.invokeMethod('requestOverlayPermission');
  }

  // ── Blocking service ──

  /// Start the foreground blocking service with the given blocked package names
  /// and active time windows encoded as a JSON string.
  static Future<void> startBlockingService({
    required List<String> blockedPackages,
    required String scheduleJson,
  }) async {
    await _channel.invokeMethod('startBlockingService', {
      'blockedPackages': blockedPackages,
      'scheduleJson': scheduleJson,
    });
  }

  static Future<void> stopBlockingService() async {
    await _channel.invokeMethod('stopBlockingService');
  }

  static Future<bool> isBlockingServiceRunning() async {
    return await _channel.invokeMethod<bool>('isBlockingServiceRunning') ??
        false;
  }

  /// Update the blocked apps list without restarting the service.
  static Future<void> updateBlockedApps(List<String> blockedPackages) async {
    await _channel.invokeMethod('updateBlockedApps', {
      'blockedPackages': blockedPackages,
    });
  }

  // ── Native bypass events ──

  /// Read and clear bypass events recorded by the native overlay.
  /// Returns { count: int, lastPackage: String? }
  static Future<Map<String, dynamic>> consumeNativeBypasses() async {
    final result = await _channel.invokeMethod('consumeNativeBypasses');
    return Map<String, dynamic>.from(result as Map);
  }

  // ── Schedule JSON hot-update ──

  /// Update the schedule JSON on a running blocking service without restart.
  static Future<void> updateScheduleJson(String scheduleJson) async {
    await _channel.invokeMethod('updateScheduleJson', {
      'scheduleJson': scheduleJson,
    });
  }

  // ── Native interval events ──

  /// Read and clear interval-usage events recorded by the native overlay.
  /// Returns { intervalsUsed: int, intervalEndTime: int? (epoch ms), intervalPackages: String? }
  static Future<Map<String, dynamic>> consumeNativeIntervals() async {
    final result = await _channel.invokeMethod('consumeNativeIntervals');
    return Map<String, dynamic>.from(result as Map);
  }

  // ── End-of-day alarm ──

  static Future<void> scheduleEndOfDayAlarm() async {
    await _channel.invokeMethod('scheduleEndOfDayAlarm');
  }

  static Future<void> cancelEndOfDayAlarm() async {
    await _channel.invokeMethod('cancelEndOfDayAlarm');
  }
}
