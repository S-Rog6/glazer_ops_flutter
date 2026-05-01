import 'package:flutter/widgets.dart';

import '../data/profiles_repository.dart';
import '../models/user_profile.dart';

class ProfilesController extends ChangeNotifier {
  ProfilesController({required ProfilesRepository repository})
    : _repository = repository;

  final ProfilesRepository _repository;

  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;
  List<UserProfile> _profiles = const [];

  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  List<UserProfile> get profiles => _profiles;

  Future<void> fetchProfiles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profiles = await _repository.fetchProfiles();
    } catch (error) {
      _errorMessage = 'Failed to load profiles: $error';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfile(UserProfile profile) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.upsertProfile(profile);
      final index = _profiles.indexWhere((p) => p.id == profile.id);
      if (index >= 0) {
        _profiles = List<UserProfile>.from(_profiles)..[index] = profile;
      } else {
        _profiles = [..._profiles, profile];
      }
      return true;
    } catch (error) {
      _errorMessage = 'Failed to save profile: $error';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> setActive(String profileId, {required bool isActive}) async {
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.setActive(profileId, isActive: isActive);
      _profiles = _profiles
          .map(
            (p) => p.id == profileId ? p.copyWith(isActive: isActive) : p,
          )
          .toList();
      return true;
    } catch (error) {
      _errorMessage = 'Failed to update profile status: $error';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}

class ProfilesControllerScope extends InheritedNotifier<ProfilesController> {
  const ProfilesControllerScope({
    super.key,
    required ProfilesController controller,
    required super.child,
  }) : super(notifier: controller);

  static ProfilesController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<ProfilesControllerScope>();
    assert(
      scope != null,
      'ProfilesControllerScope not found in widget tree.',
    );
    return scope!.notifier!;
  }
}
