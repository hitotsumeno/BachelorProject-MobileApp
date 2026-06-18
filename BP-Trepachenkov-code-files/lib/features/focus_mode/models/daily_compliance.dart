import 'package:isar/isar.dart';

part 'daily_compliance.g.dart';

@Collection()
class DailyCompliance {
  Id id = Isar.autoIncrement;

  /// Format: "2026-04-07" (local time)
  @Index(unique: true, replace: true)
  String dateKey = '';

  /// Starts true; set to false on any bypass or violation
  bool compliant = true;

  /// Number of times user bypassed a non-strict block
  int bypassCount = 0;

  /// Set to true after reward event has been emitted
  bool rewardGranted = false;

  /// Helpers
  static String keyForDate(DateTime date) {
    final d = date.toLocal();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  static String todayKey() => keyForDate(DateTime.now());
}
