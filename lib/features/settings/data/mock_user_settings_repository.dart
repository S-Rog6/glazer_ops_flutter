import '../models/user_settings.dart';
import 'user_settings_repository.dart';

class MockUserSettingsRepository implements UserSettingsRepository {
  MockUserSettingsRepository() : _settings = const UserSettings();

  UserSettings _settings;

  @override
  bool get isLiveDataSource => false;

  @override
  Future<UserSettings> fetchSettings(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _settings;
  }

  @override
  Future<void> saveSettings(String userId, UserSettings settings) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    _settings = settings;
  }
}
