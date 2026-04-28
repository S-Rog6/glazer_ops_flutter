import '../models/user_settings.dart';
import 'user_settings_repository.dart';

/// Used when Supabase is configured but could not be initialised.
/// Falls back to in-memory defaults so the app remains usable.
class UnavailableUserSettingsRepository implements UserSettingsRepository {
  const UnavailableUserSettingsRepository();

  @override
  bool get isLiveDataSource => false;

  @override
  Future<UserSettings> fetchSettings(String userId) async {
    return const UserSettings();
  }

  @override
  Future<void> saveSettings(String userId, UserSettings settings) async {
    // Settings cannot be persisted when Supabase is unavailable.
  }
}
