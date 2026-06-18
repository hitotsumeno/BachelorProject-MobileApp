import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bp_flutter_app/features/tasks/models/task.dart';
import 'package:bp_flutter_app/features/tasks/providers/task_repository.dart';
import 'package:bp_flutter_app/features/tasks/widgets/difficulty_picker.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/widgets/scheduled_date_time_picker.dart';

class TaskEditOverlay extends StatefulWidget {
  const TaskEditOverlay({super.key});

  @override
  State<TaskEditOverlay> createState() => _TaskEditOverlayState();
}

class _TaskEditOverlayState extends State<TaskEditOverlay> {
  final TextEditingController titleCntrl = TextEditingController();
  final TextEditingController noteCntrl = TextEditingController();

  DateTime? selectedDueDate;
  TaskDifficulty? taskDiffculty;
  EditMode? _lastMode;
  

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskRepository>(
      builder: (context, repo, _) {
        final mode = repo.mode;
        final task = repo.editingTask;
        final selectedDueDate = repo.overlayDueDate;
        

        if (_lastMode != mode) {
          _lastMode = mode;
          
          if (mode == EditMode.editTask && task != null) {
            titleCntrl.text = task.text;
            noteCntrl.text = task.note ?? "";
          }
  
          if (mode == EditMode.createTask) {
          titleCntrl.text = "";
          noteCntrl.text = "";
          }
        }

        final screenHeight = MediaQuery.of(context).size.height;

        return AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          left: 0,
          right: 0,
          top: mode == EditMode.none ? screenHeight : 0,
          bottom: mode == EditMode.none ? -screenHeight : 0,
          child: Material(
            color: Colors.white,
            elevation: 10,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(children: [
                      TextButton(onPressed: (){repo.closeOverlay();}, child: const Text("Cancel")),
                      const Spacer(),
                      Text(
                        mode == EditMode.createTask ? "Create Task" : "Edit Task",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      TextButton(onPressed: (){
                        repo.saveOverlay(
                          titleCntrl.text,
                          noteCntrl.text,
                          selectedDueDate,
                          repo.overlayDifficulty
                        );}, 
                        child: const Text("Save")),
                    ],),
                    
                    const SizedBox(height: 16),
                    // Title
                    TextField(
                      controller: titleCntrl,
                      decoration: InputDecoration(
                        labelText: "Title",
                        border: OutlineInputBorder(),
                        hintText: "add a new task"
                        ),
                    ),
                    
                    const SizedBox(height: 10,),
                    // Note
                    TextField(
                      controller: noteCntrl,
                      decoration: InputDecoration(
                        labelText: "Note",
                        border: OutlineInputBorder(),
                        hintText: "Add Note",
                      ),
                    ),

                    const SizedBox(height: 15,),
                    
                    // DueDate field
                    DateTimePicker(
                      selected: repo.overlayDueDate,
                      onChanged: repo.setOverlayDueDate,
                    ),
                    const SizedBox(height: 15),

                    // Difficulty selector
                    DifficultyPicker(
                      selected: repo.overlayDifficulty,
                      onChanged: repo.setOverlayDifficulty, 
                    ),

                    const Spacer(),

                    if (repo.mode == EditMode.editTask)
                      OutlinedButton(
                        onPressed: repo.deleteEditingTask, 
                        child: const Text(" Delete task ")
                      ),
                    

                    ElevatedButton(
                      onPressed: () {
                        repo.saveOverlay(
                          titleCntrl.text, 
                          noteCntrl.text,
                          repo.overlayDueDate,
                          repo.overlayDifficulty
                        );
                      },
                      child: Text(
                        mode == EditMode.createTask ? "Create" : "Save",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
