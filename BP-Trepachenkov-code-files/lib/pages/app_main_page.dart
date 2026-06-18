import 'package:flutter/material.dart';

import 'package:bp_flutter_app/features/scheduled_tasks/pages/scheduled_task_page.dart';
import 'package:bp_flutter_app/pages/settingpage.dart';
import 'package:bp_flutter_app/features/focus_mode/pages/focus_mode_page.dart';
import 'package:bp_flutter_app/features/tasks/pages/to_do_page.dart';
import 'package:bp_flutter_app/features/character/pages/character_screen.dart';
import 'package:bp_flutter_app/features/archive/pages/archive_page.dart';

class AppMainPage extends StatefulWidget
{
  const AppMainPage({super.key});

  @override
  State<AppMainPage> createState() => _AppMainPageState();
}

class _AppMainPageState extends State<AppMainPage>
{
int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (currentPageIndex)
    {
      case 0:
        page = const ToDoPage();
      case 1:
        page = const ScheduledTaskPage();
      case 2:
        page = const FocusModePage();
      case 3:
        page = const CharacterScreen();
      default:
        throw UnimplementedError('No widget for $currentPageIndex');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ArchivePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context); // close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(child: page),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Badge(child: Icon(Icons.notifications_sharp)),
            label: 'Scheduled',
          ),
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Focus',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Character',
          ),
        ],
      ),
    );
  }
}
