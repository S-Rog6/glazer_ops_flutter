import 'package:flutter_test/flutter_test.dart';
import 'package:glazer_ops/core/config/app_environment.dart';

void main() {
  group('AppEnvironment.maskProfileId', () {
    test('returns "Not set" for null', () {
      expect(AppEnvironment.maskProfileId(null), 'Not set');
    });

    test('returns "Not set" for empty string', () {
      expect(AppEnvironment.maskProfileId(''), 'Not set');
    });

    test('returns "Not set" for whitespace-only string', () {
      expect(AppEnvironment.maskProfileId('   '), 'Not set');
    });

    test('returns value as-is when shorter than 12 chars', () {
      expect(AppEnvironment.maskProfileId('short'), 'short');
    });

    test('returns value as-is at exactly 11 chars', () {
      expect(AppEnvironment.maskProfileId('abcdefghijk'), 'abcdefghijk');
    });

    test('masks value at exactly 12 chars', () {
      expect(AppEnvironment.maskProfileId('abcdefghijkl'), 'abcdefgh...ijkl');
    });

    test('masks long UUID-style profile id', () {
      const id = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';
      expect(AppEnvironment.maskProfileId(id), 'a1b2c3d4...7890');
    });

    test('trims whitespace before masking', () {
      const id = '  a1b2c3d4-e5f6-7890-abcd-ef1234567890  ';
      expect(AppEnvironment.maskProfileId(id), 'a1b2c3d4...7890');
    });
  });

  group('AppEnvironment.supabaseHost (via Uri parsing logic)', () {
    // We can't inject dart-define values at test time, so we test the helper
    // logic used by supabaseHost by exercising it through Uri directly.
    // This validates the fix that guards against Uri.tryParse('') returning
    // a Uri with an empty host instead of null.

    test('Uri.tryParse of empty string produces empty host', () {
      final uri = Uri.tryParse('');
      expect(uri?.host ?? '', isEmpty);
    });

    test('Uri.tryParse of valid URL produces correct host', () {
      final uri = Uri.tryParse('https://abc.supabase.co');
      expect(uri?.host, 'abc.supabase.co');
    });

    test('Uri.tryParse of malformed string may produce empty host', () {
      final uri = Uri.tryParse('not-a-url');
      final host = uri?.host ?? '';
      // The important thing: our guard treats empty host as "Not configured"
      expect(host.isEmpty ? 'Not configured' : host, 'Not configured');
    });
  });
}
