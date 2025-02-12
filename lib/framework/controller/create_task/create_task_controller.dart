import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/ui/utils/app_strings.dart';

final createTaskControllerProvider = ChangeNotifierProvider<CreateTaskController>((ref) {
  return CreateTaskController();
});

class CreateTaskController extends ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  Database? _database;
  bool isEditing = false;
  int? _taskId;
  bool isLoading = false;
  bool priority = false;

  /// Dispose Controller
  void disposeController({bool isNotify = false}) {
      titleController.clear();
      descriptionController.clear();
      priority = false;
    if (isNotify) {
      notifyListeners();
    }
  }

  CreateTaskController() {
    _initDatabase();
  }

  // Future<void> _initDatabase() async {
  //   _database = await openDatabase(
  //     join(await getDatabasesPath(), 'task_managers.db'),
  //     version: 1,
  //     onCreate: (db, version) {
  //       return db.execute(
  //         "CREATE TABLE IF NOT EXISTS task(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, priority BOOLEAN, status BOOLEAN DEFAULT 0, createdAt TEXT)",
  //       );
  //     },
  //   );
  //   notifyListeners();
  // }

  /// Init Db
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'task_manager.db'),
      version: 2, // Ensure this version is incremented
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE items ("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "name TEXT NOT NULL, "
            "description TEXT, "
            "priority BOOLEAN DEFAULT 0, "
            "status BOOLEAN DEFAULT 0, "
            "createdAt TEXT NOT NULL)");
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE items ADD COLUMN description TEXT;");
          await db.execute("ALTER TABLE items ADD COLUMN priority BOOLEAN DEFAULT 0;");
          await db.execute("ALTER TABLE items ADD COLUMN status BOOLEAN DEFAULT 0;");
          await db.execute("ALTER TABLE items ADD COLUMN createdAt TEXT NOT NULL;");
        }
      },
    );

    debugPrint("--------------------------Database initialized successfully--------------------------");
    notifyListeners();
  }

  /// Update Priority
  void setPriority(bool value) {
    priority = value;
    notifyListeners();
  }

  /// Load Task When Coming From Edit Icon
  Future<void> loadTask(int id) async {
    if (_database == null) return;

    final List<Map<String, dynamic>> taskData = await _database!.query('items', where: 'id = ?', whereArgs: [id]);

    if (taskData.isNotEmpty) {
      isEditing = true;
      _taskId = id;
      titleController.text = taskData.first['name'];
      descriptionController.text = taskData.first['description'] ?? "";
      priority = taskData.first['priority'] == 1;
      notifyListeners();
    }
  }

  /// Save Task In DB
  Future<void> saveTask(BuildContext context) async {
    if (_database == null || titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.pleaseEnterSomething)),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final taskData = {
        'name': titleController.text,
        'description': descriptionController.text,
        'priority': priority ? 1 : 0,
        'status': 0, // false by default
        'createdAt': DateTime.now().toIso8601String(),
      };

      if (isEditing && _taskId != null) {
        await _database!.update(
          'items',
          taskData,
          where: 'id = ?',
          whereArgs: [_taskId],
        );
      } else {
        await _database!.insert('items', taskData);
      }

      isLoading = false;
      notifyListeners();
      Navigator.pop(context, true);
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }
}
