import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/config/app_environment.dart';
import 'core/supabase/supabase_bootstrap.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/jobs/controllers/jobs_controller.dart';
import 'features/jobs/data/jobs_repository.dart';
import 'features/jobs/data/supabase_jobs_repository.dart';
import 'features/jobs/data/unavailable_jobs_repository.dart';
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
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    _jobsRepository = SupabaseBootstrap.state.isReady
        ? SupabaseJobsRepository(Supabase.instance.client)
        : UnavailableJobsRepository(SupabaseBootstrap.state);
    _jobsController = JobsController(
      repository: _jobsRepository,
      activeUserId: _resolveActiveUserId(),
    );
    unawaited(_jobsController.fetchJobs());

    if (SupabaseBootstrap.state.isReady) {
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange
          .listen((data) {
            final didChangeActiveUser = _jobsController.updateActiveUserId(
              _resolveActiveUserId(session: data.session),
            );
            if (didChangeActiveUser) {
              unawaited(_jobsController.fetchJobs());
            }
          });
    }
  }

  String? _resolveActiveUserId({Session? session}) {
    final configuredProfileId = AppEnvironment.activeProfileId;
    if (configuredProfileId != null) {
      return configuredProfileId;
    }

    final sessionUserId = session?.user.id;
    if (sessionUserId != null && sessionUserId.trim().isNotEmpty) {
      return sessionUserId;
    }

    if (!SupabaseBootstrap.state.isReady) {
      return null;
    }

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null || currentUserId.trim().isEmpty) {
      return null;
    }

    return currentUserId;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
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
