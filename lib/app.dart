import 'dart:async';

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
import 'features/jobs/data/unavailable_jobs_repository.dart';
import 'features/settings/controllers/user_settings_controller.dart';
import 'features/settings/data/mock_user_settings_repository.dart';
import 'features/settings/data/supabase_user_settings_repository.dart';
import 'features/settings/data/unavailable_user_settings_repository.dart';
import 'features/settings/data/user_settings_repository.dart';
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
  late final UserSettingsRepository _userSettingsRepository;
  late final UserSettingsController _userSettingsController;
  StreamSubscription<AuthState>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _themeController = ThemeController();
    final bootstrapState = SupabaseBootstrap.state;

    _jobsRepository = bootstrapState.isReady
        ? SupabaseJobsRepository(Supabase.instance.client)
        : bootstrapState.isConfigured
        ? UnavailableJobsRepository(bootstrapState)
        : const MockJobsRepository();

    _userSettingsRepository = bootstrapState.isReady
        ? SupabaseUserSettingsRepository(Supabase.instance.client)
        : bootstrapState.isConfigured
        ? const UnavailableUserSettingsRepository()
        : MockUserSettingsRepository();

    _jobsController = JobsController(
      repository: _jobsRepository,
      activeUserId: _resolveActiveUserId(),
    );
    _userSettingsController = UserSettingsController(
      repository: _userSettingsRepository,
    );

    unawaited(_jobsController.fetchJobs());
    unawaited(_userSettingsController.fetchSettings(_resolveActiveUserId()));

    if (SupabaseBootstrap.state.isReady) {
      _authSubscription = Supabase.instance.client.auth.onAuthStateChange
          .listen((data) {
            final activeUserId = _resolveActiveUserId(session: data.session);
            final didChangeActiveUser = _jobsController.updateActiveUserId(
              activeUserId,
            );
            if (didChangeActiveUser) {
              unawaited(_jobsController.fetchJobs());
              unawaited(_userSettingsController.fetchSettings(activeUserId));
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
    _userSettingsController.dispose();
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
          child: UserSettingsRepositoryScope(
            repository: _userSettingsRepository,
            child: UserSettingsControllerScope(
              controller: _userSettingsController,
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
        ),
      ),
    );
  }
}
