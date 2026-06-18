import 'package:bp_flutter_app/core/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bp_flutter_app/core/services/isar_service.dart';
import 'package:bp_flutter_app/features/tasks/providers/task_repository.dart';
import 'package:bp_flutter_app/features/scheduled_tasks/providers/scheduled_task_repository.dart';
import 'package:bp_flutter_app/features/character/providers/character_notifier.dart';
import 'package:bp_flutter_app/features/focus_mode/providers/focus_mode_provider.dart';

import 'package:bp_flutter_app/pages/app_main_page.dart';
import 'package:bp_flutter_app/core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarService.init();
  await NotificationService().init();

  final characterNotifier = CharacterNotifier();
  await characterNotifier.loadCharacter();

  final scheduledTaskRepository = ScheduledTaskRepository(characterNotifier);
  await scheduledTaskRepository.init();

  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider.value(value: characterNotifier),
        ChangeNotifierProvider( create: (context) => TaskRepository(characterNotifier)),
        ChangeNotifierProvider.value(value: scheduledTaskRepository),
        ChangeNotifierProvider( create: (context) => FocusModeProvider(characterNotifier)),
        ChangeNotifierProvider( create: (context) => ThemeProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const AppMainPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
