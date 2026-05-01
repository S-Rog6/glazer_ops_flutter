import '../models/user_profile.dart';
import 'profiles_repository.dart';

/// Used when Supabase is configured but could not be initialised.
/// All operations are no-ops so the app remains usable.
class UnavailableProfilesRepository implements ProfilesRepository {
  const UnavailableProfilesRepository();

  @override
  bool get isLiveDataSource => false;

  @override
  Future<List<UserProfile>> fetchProfiles() async {
    return const <UserProfile>[];
  }

  @override
  Future<void> upsertProfile(UserProfile profile) async {
    // Cannot persist profiles when Supabase is unavailable.
  }

  @override
  Future<void> setActive(String profileId, {required bool isActive}) async {
    // Cannot update profile when Supabase is unavailable.
  }
}
