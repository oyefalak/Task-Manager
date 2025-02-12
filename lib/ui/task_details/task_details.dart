import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:task_manager/framework/controller/dashboard/dashboard_controller.dart';
import 'package:task_manager/framework/model/task_model.dart';
import 'package:task_manager/ui/utils/anim/fadedbox_transition.dart';

class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final dashboardController = ref.watch(dashboardControllerProvider);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Icon(CupertinoIcons.back),
            ),
            title: const Text("Task Details"),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: FadeBoxTransition(
            child: Padding(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Description: ${task.description.isNotEmpty ? task.description : "No description"}",
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text("Priority: ", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Icon(
                        task.priority ? Icons.star : Icons.star_border,
                        color: task.priority ? Colors.orange : Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Text("Status: ", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                      Text(
                        task.status ? "Completed" : "Pending",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: task.status ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Created At: ${dashboardController.formatDate(task.createdAt)}",
                    style: TextStyle(fontSize: 18.sp, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
