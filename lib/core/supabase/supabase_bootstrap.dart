import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_environment.dart';

class SupabaseBootstrapState {
  const SupabaseBootstrapState({
    required this.isConfigured,
    required this.isReady,
    required this.message,
  });

  const SupabaseBootstrapState.notConfigured()
    : isConfigured = false,
      isReady = false,
      message =
          'Supabase URL/key are not configured. Live data is unavailable until the app is launched with valid Supabase values.';

  final bool isConfigured;
  final bool isReady;
  final String message;
}

class SupabaseBootstrap {
  static SupabaseBootstrapState _state =
      const SupabaseBootstrapState.notConfigured();

  static SupabaseBootstrapState get state => _state;

  static Future<void> initialize() async {
    if (!AppEnvironment.isSupabaseConfigured) {
      _state = const SupabaseBootstrapState.notConfigured();
      return;
    }

    try {
      await Supabase.initialize(
        url: AppEnvironment.supabaseUrl,
        anonKey: AppEnvironment.supabaseAnonKey,
      );

      _state = const SupabaseBootstrapState(
        isConfigured: true,
        isReady: true,
        message: 'Supabase initialized successfully.',
      );
    } catch (error) {
      _state = SupabaseBootstrapState(
        isConfigured: true,
        isReady: false,
        message:
            'Supabase initialization failed. Live data is unavailable. Error: $error',
      );
    }
  }
}
