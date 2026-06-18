import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:bp_flutter_app/features/focus_mode/services/focus_mode_service.dart';

/// Data class for an installed app.
class InstalledAppInfo {
  final String packageName;
  final String appName;
  final Uint8List? icon;

  const InstalledAppInfo({
    required this.packageName,
    required this.appName,
    this.icon,
  });
}

/// Full-screen dialog to pick installed apps for a focus group.
class AppPickerDialog extends StatefulWidget {
  const AppPickerDialog({
    super.key,
    required this.alreadySelected,
  });

  final List<String> alreadySelected;

  @override
  State<AppPickerDialog> createState() => _AppPickerDialogState();
}

class _AppPickerDialogState extends State<AppPickerDialog> {
  List<InstalledAppInfo> _allApps = [];
  List<InstalledAppInfo> _filtered = [];
  final Set<String> _selected = {};
  bool _loading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected.addAll(widget.alreadySelected);
    _loadApps();
  }

  Future<void> _loadApps() async {
    try {
      final rawApps = await FocusModeService.getInstalledApps();
      final apps = rawApps
          .map((m) => InstalledAppInfo(
                packageName: m['packageName'] as String,
                appName: m['appName'] as String,
                icon: m['icon'] as Uint8List?,
              ))
          .toList()
        ..sort((a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()));
      setState(() {
        _allApps = apps;
        _filtered = apps;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _filter(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filtered = _allApps
          .where((a) =>
              a.appName.toLowerCase().contains(q) ||
              a.packageName.toLowerCase().contains(q))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Apps'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _selected.toList()),
            child: const Text('Done'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search apps...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filter,
            ),
          ),
          if (_loading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final app = _filtered[index];
                  final isSelected = _selected.contains(app.packageName);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selected.add(app.packageName);
                        } else {
                          _selected.remove(app.packageName);
                        }
                      });
                    },
                    secondary: app.icon != null
                        ? Image.memory(app.icon!, width: 40, height: 40)
                        : const Icon(Icons.android),
                    title: Text(app.appName),
                    subtitle: Text(
                      app.packageName,
                      style: const TextStyle(fontSize: 11),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
