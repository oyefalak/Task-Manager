import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/framework/controller/create_task/create_task_controller.dart';
import 'package:task_manager/ui/utils/anim/fadedbox_transition.dart';
import 'package:task_manager/ui/utils/app_strings.dart';
import 'package:task_manager/ui/utils/common_button.dart';

class CreateTask extends ConsumerStatefulWidget {
  final int? taskId;

  const CreateTask({super.key, this.taskId});

  @override
  ConsumerState<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends ConsumerState<CreateTask> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final taskController = ref.read(createTaskControllerProvider);
      taskController.disposeController(isNotify: true);
      if (widget.taskId != null) {
        taskController.loadTask(widget.taskId!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskController = ref.watch(createTaskControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(CupertinoIcons.back),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(taskController.isEditing ? AppStrings.editTask : AppStrings.createTask),
      ),
      body: FadeBoxTransition(
        child: Padding(
          padding: EdgeInsets.all(16.h),
          child: Column(
            children: [
              TextFormField(
                controller: taskController.titleController,
                decoration: const InputDecoration(
                  labelText: AppStrings.enterTask,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: taskController.descriptionController,
                decoration: const InputDecoration(
                  labelText: "Enter Description",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Checkbox(
                    value: taskController.priority,
                    onChanged: (value) {
                      taskController.setPriority(value ?? false);
                    },
                  ),
                  const Text("Priority")
                ],
              ),
              const Spacer(),
              taskController.isLoading
                  ? const CircularProgressIndicator()
                  : CommonButton(
                text: taskController.isEditing ? AppStrings.update : AppStrings.create,
                onTap: () {
                  taskController.saveTask(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}