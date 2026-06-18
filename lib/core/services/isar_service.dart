import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/tasks/models/task.dart';
import '../../features/scheduled_tasks/models/scheduled_task.dart';
import '../../features/character/models/character.dart';
import '../../features/focus_mode/models/focus_group.dart';
import '../../features/focus_mode/models/daily_compliance.dart';

class IsarService {
  static late Isar _isar;

  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    
    _isar = await Isar.open(
      [
        TaskSchema,
        ScheduledTaskSchema,
        CharacterSchema,
        FocusGroupSchema,
        DailyComplianceSchema,
      ],
      directory: dir.path,
    );
  }

  static Isar get isar => _isar;
}