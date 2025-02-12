import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/framework/controller/create_task/create_task_controller.dart';
import 'package:task_manager/framework/controller/dashboard/dashboard_controller.dart';
import 'package:task_manager/ui/utils/anim/fadedbox_transition.dart';
import 'package:task_manager/ui/utils/app_routes.dart';
import 'package:task_manager/ui/utils/app_strings.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider);
    final taskController = ref.watch(createTaskControllerProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(controller.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => controller.toggleTheme(),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.tasks.isEmpty
              ? const Center(child: Text(AppStrings.noTasksAvailable))
              : ListView.builder(
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks[index];

                    return FadeBoxTransition(
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: TextStyle(decoration: task.status ? TextDecoration.lineThrough : null),
                          ),
                          subtitle: Text("Created at: ${controller.formatDate(task.createdAt)}"),
                          onTap: () {
                            context.push(AppRoutes.taskDetails, extra: task);
                          },
                          leading: Checkbox(
                            value: task.status,
                            onChanged: (bool? value) {
                              controller.updateTaskStatus(task.id, value ?? false);
                            },
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              task.status
                                  ? Offstage()
                                  : IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.purple),
                                      onPressed: () async {
                                        await context.push(AppRoutes.createTask, extra: task.id);
                                        controller.fetchTasks(); // Refresh list after editing
                                      },
                                    ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller.deleteTask(task.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          taskController.isEditing = false;
          await context.push(AppRoutes.createTask); // Navigate to CreateTask for new task
          controller.fetchTasks(); // Refresh list when returning
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
