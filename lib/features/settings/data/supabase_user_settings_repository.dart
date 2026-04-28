import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_settings.dart';
import 'user_settings_repository.dart';

class SupabaseUserSettingsRepository implements UserSettingsRepository {
  SupabaseUserSettingsRepository(this._client);

  final SupabaseClient _client;

  @override
  bool get isLiveDataSource => true;

  @override
  Future<UserSettings> fetchSettings(String userId) async {
    try {
      final row = await _client
          .from('user_settings')
          .select(
            'card_actions_side, zoom, schedule_view, calculator_enabled',
          )
          .eq('user_id', userId)
          .maybeSingle();

      if (row == null) {
        return const UserSettings();
      }

      return UserSettings.fromJson(Map<String, dynamic>.from(row));
    } on PostgrestException catch (error) {
      throw _formatError(action: 'load user settings from Supabase', error: error);
    } catch (error) {
      throw Exception('Failed to load user settings from Supabase. Error: $error');
    }
  }

  @override
  Future<void> saveSettings(String userId, UserSettings settings) async {
    try {
      await _client.from('user_settings').upsert({
        'user_id': userId,
        ...settings.toJson(),
      });
    } on PostgrestException catch (error) {
      throw _formatError(action: 'save user settings to Supabase', error: error);
    } catch (error) {
      throw Exception('Failed to save user settings to Supabase. Error: $error');
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
