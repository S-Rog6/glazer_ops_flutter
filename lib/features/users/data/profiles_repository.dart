import 'package:flutter/widgets.dart';

import '../models/user_profile.dart';

abstract interface class ProfilesRepository {
  bool get isLiveDataSource;

  Future<List<UserProfile>> fetchProfiles();

  Future<void> upsertProfile(UserProfile profile);

  Future<void> setActive(String profileId, {required bool isActive});
}

class ProfilesRepositoryScope extends InheritedWidget {
  const ProfilesRepositoryScope({
    super.key,
    required this.repository,
    required super.child,
  });

  final ProfilesRepository repository;

  static ProfilesRepository of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ProfilesRepositoryScope>();
    assert(
      scope != null,
      'ProfilesRepositoryScope not found in widget tree.',
    );
    return scope!.repository;
  }

  @override
  bool updateShouldNotify(covariant ProfilesRepositoryScope oldWidget) {
    return repository != oldWidget.repository;
  }
}
