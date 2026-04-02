class AppEnvironment {
  static const String _supabaseUrl =
      String.fromEnvironment('SUPABASE_URL');
  static const String _nextPublicSupabaseUrl =
      String.fromEnvironment('NEXT_PUBLIC_SUPABASE_URL');
  static const String _supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');
  static const String _nextPublicSupabasePublishableKey =
      String.fromEnvironment(
        'NEXT_PUBLIC_SUPABASE_PUBLISHABLE_DEFAULT_KEY',
      );
  static const String _supabaseProfileId =
      String.fromEnvironment('SUPABASE_PROFILE_ID');
  static const String _nextPublicSupabaseProfileId =
      String.fromEnvironment('NEXT_PUBLIC_SUPABASE_PROFILE_ID');

  static String get supabaseUrl =>
      _supabaseUrl.isNotEmpty ? _supabaseUrl : _nextPublicSupabaseUrl;

  static String get supabaseAnonKey =>
      _supabaseAnonKey.isNotEmpty
          ? _supabaseAnonKey
          : _nextPublicSupabasePublishableKey;

  static String get supabaseProfileId =>
      _supabaseProfileId.isNotEmpty
          ? _supabaseProfileId
          : _nextPublicSupabaseProfileId;

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get hasActiveProfileId => activeProfileId != null;

  static String? get activeProfileId =>
      supabaseProfileId.trim().isEmpty ? null : supabaseProfileId.trim();

  static String get supabaseHost {
    final uri = Uri.tryParse(supabaseUrl);
    return uri?.host ?? 'Not configured';
  }

  static String get maskedProfileId {
    final profileId = activeProfileId;
    if (profileId == null || profileId.length < 12) {
      return profileId ?? 'Not set';
    }

    return '${profileId.substring(0, 8)}...${profileId.substring(profileId.length - 4)}';
  }
}
