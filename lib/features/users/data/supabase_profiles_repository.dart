import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import 'profiles_repository.dart';

class SupabaseProfilesRepository implements ProfilesRepository {
  SupabaseProfilesRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get isLiveDataSource => true;

  @override
  Future<List<UserProfile>> fetchProfiles() async {
    try {
      final rows = await _client
          .from('profiles')
          .select()
          .order('full_name');
      return (rows as List<dynamic>)
          .map((row) => UserProfile.fromJson(Map<String, dynamic>.from(row as Map)))
          .toList();
    } on PostgrestException catch (error) {
      throw _formatError(action: 'load profiles from Supabase', error: error);
    } catch (error) {
      throw Exception('Failed to load profiles from Supabase. Error: $error');
    }
  }

  @override
  Future<void> upsertProfile(UserProfile profile) async {
    try {
      await _client.from('profiles').upsert(profile.toJson());
    } on PostgrestException catch (error) {
      throw _formatError(action: 'save profile to Supabase', error: error);
    } catch (error) {
      throw Exception('Failed to save profile to Supabase. Error: $error');
    }
  }

  @override
  Future<void> setActive(String profileId, {required bool isActive}) async {
    try {
      await _client
          .from('profiles')
          .update({'is_active': isActive})
          .eq('id', profileId);
    } on PostgrestException catch (error) {
      throw _formatError(
        action: 'update profile active status in Supabase',
        error: error,
      );
    } catch (error) {
      throw Exception(
        'Failed to update profile active status in Supabase. Error: $error',
      );
    }
  }

  Exception _formatError({
    required String action,
    required PostgrestException error,
  }) {
    final parts = <String>['Failed to $action.', error.message];

    if (error.code != null && error.code!.trim().isNotEmpty) {
      parts.add('Code: ${error.code}.');
    }

    if (error.hint != null && error.hint!.trim().isNotEmpty) {
      parts.add('Hint: ${error.hint}.');
    }

    final details = error.details?.toString().trim();
    if (details != null && details.isNotEmpty) {
      parts.add('Details: $details.');
    }

    return Exception(parts.join(' '));
  }
}
