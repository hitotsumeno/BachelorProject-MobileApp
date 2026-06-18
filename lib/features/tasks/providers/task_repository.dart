import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import '../models/task.dart';
import '../../../core/services/isar_service.dart';
import '../../character/providers/character_notifier.dart';
import '../models/task_reward.dart';

enum EditMode {none, createTask, editTask}

class TaskRepository extends ChangeNotifier {
  final Isar _isar = IsarService.isar;
  final CharacterNotifier _characterNotifier;

  TaskRepository(this._characterNotifier);

  final List<Task> currentTasks = [];
  final List<Task> archivedTasks = [];


  EditMode _mode = EditMode.none;
  EditMode get mode => _mode;

  TaskDifficulty _overlayDifficulty = TaskDifficulty.easy;
  TaskDifficulty get overlayDifficulty => _overlayDifficulty;
  
  Task? _editingTask;
  Task? get editingTask => _editingTask;
  
  DateTime? _overlayDueDate;
  DateTime? get overlayDueDate => _overlayDueDate; 

  bool get isOverlayOpen => _mode != EditMode.none;

  
  Future<void> addTask(Task task) async {
    await _isar.writeTxn(()async {
      await _isar.tasks.put(task);
    });

    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final all = await _isar.tasks.where().findAll();
    currentTasks.clear();
    archivedTasks.clear();
    currentTasks.addAll(all.where((t) => !t.isDone));
    archivedTasks.addAll(all.where((t) => t.isDone));
    notifyListeners();
  }

  Future<TaskReward?> toggleTask(Id id) async {
    TaskReward? reward;
    await _isar.writeTxn(() async {
      final task = await _isar.tasks.get(id);
      if (task != null) {
        final wasCompleted = task.isDone;
        task.isDone = !task.isDone;
        await _isar.tasks.put(task);

        if (!wasCompleted) {
          reward = _characterNotifier.completeTask(task.diffculty);
        } else {
          _characterNotifier.failTask(task.diffculty);
        }
      }
    });
    await fetchTasks();
    return reward;
  }

  Future<void> deleteTask (int id) async {
    await _isar.writeTxn(() => _isar.tasks.delete(id));
    await fetchTasks();
  }

  Future<void> deleteEditingTask () async {
    if (editingTask == null) return;

    await _isar.writeTxn(() async{
     await _isar.tasks.delete(_editingTask!.id); 
    });

    closeOverlay();
    fetchTasks();
  }
  

  Future<void> restoreTask(Id id) async {
    await _isar.writeTxn(() async {
      final task = await _isar.tasks.get(id);
      if (task != null) {
        task.isDone = false;
        await _isar.tasks.put(task);
      }
    });
    await fetchTasks();
  }

  // Open Create menu
  void openCreate() {
    _editingTask = null;
    _overlayDueDate = null;
    _overlayDifficulty = TaskDifficulty.easy;
    _mode = EditMode.createTask;
    notifyListeners();
  }

  void openEdit(Task task) {
    _editingTask = task;
    _overlayDueDate = task.dueDate;
    _overlayDifficulty = task.diffculty;
    _mode = EditMode.editTask;
    notifyListeners();
  }

  void closeOverlay() {
    _editingTask = null;
    _mode = EditMode.none;
    notifyListeners();
  }

  void setOverlayDueDate(DateTime? date){
    _overlayDueDate = date;
    notifyListeners();
  }

  void setOverlayDifficulty(TaskDifficulty diffculty)
  {
    _overlayDifficulty = diffculty;
    notifyListeners();
  }

  Future<void> saveOverlay(String titleTask, String? noteTask, DateTime? dueDate, TaskDifficulty diffculty) async {
    // Create Mode 
    if (_mode == EditMode.createTask) {
      final newTask = Task()
      ..text = titleTask
      ..note = noteTask
      ..dueDate = dueDate
      ..diffculty = diffculty;

      await _isar.writeTxn(() async{
        await _isar.tasks.put(newTask);
      });
    }
    // Edit Mode
    if (_mode == EditMode.editTask && _editingTask != null) {
      await _isar.writeTxn(() async{
        final taskUpd =_editingTask!;
        taskUpd.text = titleTask;
        taskUpd.note = noteTask;
        taskUpd.dueDate = dueDate;
        taskUpd.diffculty = diffculty;

        await _isar.tasks.put(taskUpd);
      });
    }
    await fetchTasks();
    closeOverlay();
  }

}