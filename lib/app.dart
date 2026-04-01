import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/jobs/controllers/jobs_controller.dart';
import 'routes/app_router.dart';

class GlazerOpsApp extends StatefulWidget {
  const GlazerOpsApp({super.key});

  @override
  State<GlazerOpsApp> createState() => _GlazerOpsAppState();
}

class _GlazerOpsAppState extends State<GlazerOpsApp> {
  final ThemeController _themeController = ThemeController();
  final JobsController _jobsController = JobsController();

  @override
  void initState() {
    super.initState();
    // Simulate initial fetch of data
    _jobsController.fetchJobs();
  }

  @override
  void dispose() {
    _jobsController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeControllerScope(
      controller: _themeController,
      child: JobsControllerScope(
        controller: _jobsController,
        child: AnimatedBuilder(
          animation: _themeController,
          builder: (context, _) {
            return MaterialApp(
              title: 'GlazerOps',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: _themeController.themeMode,
              debugShowCheckedModeBanner: false,
              initialRoute: AppRouter.splash,
              onGenerateRoute: AppRouter.generateRoute,
            );
          },
        ),
      ),
    );
  }
}
