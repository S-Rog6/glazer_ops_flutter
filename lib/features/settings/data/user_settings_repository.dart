import 'package:flutter/widgets.dart';

import '../models/user_settings.dart';

abstract interface class UserSettingsRepository {
  bool get isLiveDataSource;

  Future<UserSettings> fetchSettings(String userId);

  Future<void> saveSettings(String userId, UserSettings settings);
}

class UserSettingsRepositoryScope extends InheritedWidget {
  const UserSettingsRepositoryScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final UserSettingsRepository repository;

  static UserSettingsRepository of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<UserSettingsRepositoryScope>();
    assert(
      scope != null,
      'UserSettingsRepositoryScope not found in widget tree.',
    );
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(covariant UserSettingsRepositoryScope oldWidget) {
    return repository != oldWidget.repository;
  }
}
