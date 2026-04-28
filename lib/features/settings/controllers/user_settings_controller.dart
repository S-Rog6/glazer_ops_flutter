import 'package:flutter/widgets.dart';

import '../data/user_settings_repository.dart';
import '../models/user_settings.dart';

class UserSettingsController extends ChangeNotifier {
  UserSettingsController({required UserSettingsRepository repository})
    : _repository = repository;

  final UserSettingsRepository _repository;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  UserSettings _settings = const UserSettings();

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  UserSettings get settings => _settings;

  Future<void> fetchSettings(String? userId) async {
    if (userId == null || userId.trim().isEmpty) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _settings = await _repository.fetchSettings(userId.trim());
    } catch (error) {
      _errorMessage = 'Failed to load user settings: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSettings(String? userId, UserSettings settings) async {
    if (userId == null || userId.trim().isEmpty) {
      _settings = settings;
      notifyListeners();
      return;
    }

    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveSettings(userId.trim(), settings);
      _settings = settings;
    } catch (error) {
      _errorMessage = 'Failed to save user settings: $error';
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}

class UserSettingsControllerScope
    extends InheritedNotifier<UserSettingsController> {
  const UserSettingsControllerScope({
    super.key,
    required UserSettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static UserSettingsController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<UserSettingsControllerScope>();
    assert(
      scope != null,
      'UserSettingsControllerScope not found in widget tree.',
    );
    return scope!.notifier!;
  }
}
