import '../models/user_profile.dart';
import 'profiles_repository.dart';

final List<UserProfile> _mockProfiles = [
  UserProfile(
    id: '11111111-1111-1111-1111-111111111111',
    email: 'morgan.shaw@example.com',
    fullName: 'Morgan Shaw',
    phone: '312-555-0100',
    isActive: true,
    createdAt: DateTime(2025, 1, 15),
  ),
  UserProfile(
    id: '22222222-2222-2222-2222-222222222222',
    email: 'avery.brooks@example.com',
    fullName: 'Avery Brooks',
    phone: '312-555-0101',
    isActive: true,
    createdAt: DateTime(2025, 2, 3),
  ),
  UserProfile(
    id: '33333333-3333-3333-3333-333333333333',
    email: 'jamie.patel@example.com',
    fullName: 'Jamie Patel',
    phone: '312-555-0102',
    isActive: true,
    createdAt: DateTime(2025, 3, 10),
  ),
  UserProfile(
    id: '44444444-4444-4444-4444-444444444444',
    email: 'taylor.reed@example.com',
    fullName: 'Taylor Reed',
    phone: null,
    isActive: false,
    createdAt: DateTime(2025, 4, 20),
  ),
];

class MockProfilesRepository implements ProfilesRepository {
  MockProfilesRepository()
    : _profiles = List<UserProfile>.from(_mockProfiles);

  final List<UserProfile> _profiles;

  @override
  bool get isLiveDataSource => false;

  @override
  Future<List<UserProfile>> fetchProfiles() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<UserProfile>.from(_profiles);
  }

  @override
  Future<void> upsertProfile(UserProfile profile) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _profiles.indexWhere((p) => p.id == profile.id);
    if (index >= 0) {
      _profiles[index] = profile;
    } else {
      _profiles.add(profile);
    }
  }

  @override
  Future<void> setActive(String profileId, {required bool isActive}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _profiles.indexWhere((p) => p.id == profileId);
    if (index >= 0) {
      _profiles[index] = _profiles[index].copyWith(isActive: isActive);
    }
  }
}
