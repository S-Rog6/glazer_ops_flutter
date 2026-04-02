import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_environment.dart';
import 'core/supabase/supabase_bootstrap.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/jobs/controllers/jobs_controller.dart';
import 'features/jobs/data/jobs_repository.dart';
import 'features/jobs/data/mock_jobs_repository.dart';
import 'features/jobs/data/supabase_jobs_repository.dart';
import 'routes/app_router.dart';

class GlazerOpsApp extends StatefulWidget {
  const GlazerOpsApp({super.key});

  @override
  State<GlazerOpsApp> createState() => _GlazerOpsAppState();
}

class _GlazerOpsAppState extends State<GlazerOpsApp> {
  late final ThemeController _themeController;
  late final JobsRepository _jobsRepository;
  late final JobsController _jobsController;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _jobsRepository = SupabaseBootstrap.state.isReady
        ? SupabaseJobsRepository(Supabase.instance.client)
        : const MockJobsRepository();
    _jobsController = JobsController(
      repository: _jobsRepository,
      activeUserId: SupabaseBootstrap.state.isReady
          ? AppEnvironment.activeProfileId
          : MockJobsRepository.defaultActiveUserId,
    );
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
      child: JobsRepositoryScope(
        repository: _jobsRepository,
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
      ),
    );
  }
}
