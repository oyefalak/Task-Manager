import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/framework/model/task_model.dart';
import 'package:task_manager/framework/utility/session.dart';

// Provider for DashboardController
final dashboardControllerProvider = ChangeNotifierProvider<DashboardController>((ref) {
  return DashboardController();
});

class DashboardController extends ChangeNotifier {
  List<Task> tasks = [];
  Database? _database;
  bool isLoading = false;
  ThemeMode themeMode = ThemeMode.light;

  DashboardController() {
    _initDatabase();
    _loadTheme();
  }

  /// Load theme from Hive
  void _loadTheme() {
    final isDarkMode = Session.getIsAppThemeDark() ?? false;
    themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  /// Toggle Theme and Save to Hive
  void toggleTheme() {
    themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Session.setIsThemeModeDark(themeMode == ThemeMode.dark);
    notifyListeners();
  }

  /// Initialize database
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'task_manager.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE IF NOT EXISTS items (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT, priority BOOLEAN, status BOOLEAN, createdAt TEXT)",
        );
      },
    );
    fetchTasks();
  }

  /// Fetch tasks from database
  // Future<void> fetchTasks() async {
  //   if (_database == null) return;
  //
  //   isLoading = true;
  //   notifyListeners();
  //
  //   final List<Map<String, dynamic>> data = await _database!.query('items');
  //   tasks = data.map((task) => Task.fromMap(task)).toList();
  //
  //   isLoading = false;
  //   notifyListeners();
  // }
  Future<void> fetchTasks() async {
    if (_database == null) return;

    isLoading = true;
    notifyListeners();

    final List<Map<String, dynamic>> data = await _database!.query('items');

    tasks = data.map((task) => Task.fromMap(task)).toList();

    // **Sort by Priority (High first), then by Date (Newest first)**
    tasks.sort((a, b) {
      if (a.priority == b.priority) {
        return b.createdAt.compareTo(a.createdAt); // Newest first
      }
      return b.priority ? 1 : -1; // High priority first
    });

    isLoading = false;
    notifyListeners();
  }

  /// Update Task Status
  Future<void> updateTaskStatus(int id, bool newStatus) async {
    if (_database == null) return;

    await _database!.update(
      'items',
      {'status': newStatus ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );

    fetchTasks();
  }

  /// Delete a task from database
  Future<void> deleteTask(int id) async {
    if (_database == null) return;

    await _database!.delete('items', where: 'id = ?', whereArgs: [id]);
    fetchTasks();
  }

  /// Dispose controller
  void disposeController({bool isNotify = false}) {
    _database?.close();
    if (isNotify) {
      notifyListeners();
    }
  }

  /// Format date as "13 Feb 2025 | 2:25AM"
  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat("d MMM yyyy | h:mma").format(parsedDate);
    } catch (e) {
      return date;
    }
  }
}