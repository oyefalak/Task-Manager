import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/framework/controller/dashboard/dashboard_controller.dart';
import 'package:task_manager/framework/model/task_model.dart';
import 'package:task_manager/ui/create_task/create_task.dart';
import 'package:task_manager/ui/dashboard/dashboard.dart';
import 'package:task_manager/ui/splash/splash.dart';
import 'package:task_manager/ui/task_details/task_details.dart';
import 'package:task_manager/ui/utils/app_routes.dart';
import 'package:task_manager/ui/utils/app_strings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardController = ref.watch(dashboardControllerProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: AppStrings.taskManager,
          debugShowCheckedModeBanner: false,
          themeMode: dashboardController.themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          routerConfig: _router(),
        );
      },
    );
  }
}

GoRouter _router() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const Dashboard(),
      ),
      GoRoute(
        path: AppRoutes.createTask,
        builder: (context, state) {
          final taskId = state.extra as int?;
          return CreateTask(taskId: taskId);
        },
      ),
      GoRoute(
        path: AppRoutes.taskDetails,
        builder: (context, state) {
          final task = state.extra as Task;
          return TaskDetailsScreen(task: task);
        },
      ),
    ],
  );
}
