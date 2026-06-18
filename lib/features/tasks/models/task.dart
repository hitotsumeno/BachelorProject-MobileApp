import 'package:isar/isar.dart';
//this line is needed to generate file
// then .: flutter run build_runner build
part 'task.g.dart';

enum TaskDifficulty{easy, medium, hard}

@Collection()
class Task {
  Id id = Isar.autoIncrement;
  late String text;
  String? note;
  
  DateTime? dueDate;
  
  @enumerated
  TaskDifficulty diffculty =  TaskDifficulty.easy;
  
  bool isDone = false;
}