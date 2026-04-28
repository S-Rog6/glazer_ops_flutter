import 'package:flutter_test/flutter_test.dart';
import 'package:glazer_ops/core/utils/retry.dart';

class _TestException implements Exception {
  const _TestException(this.message);
  final String message;

  @override
  String toString() => message;
}

void main() {
  group('withRetry', () {
    test('returns value immediately when operation succeeds on first attempt',
        () async {
      final result = await withRetry(() async => 42);
      expect(result, 42);
    });

    test('retries and returns value when operation succeeds on second attempt',
        () async {
      var callCount = 0;
      final result = await withRetry(
        () async {
          callCount++;
          if (callCount < 2) throw const _TestException('transient');
          return 'ok';
        },
        initialDelay: Duration.zero,
      );

      expect(result, 'ok');
      expect(callCount, 2);
    });

    test('retries up to maxAttempts before rethrowing', () async {
      var callCount = 0;
      await expectLater(
        withRetry(
          () async {
            callCount++;
            throw const _TestException('always fails');
          },
          maxAttempts: 3,
          initialDelay: Duration.zero,
        ),
        throwsA(isA<_TestException>()),
      );

      expect(callCount, 3);
    });

    test('does not retry when retryIf returns false', () async {
      var callCount = 0;
      await expectLater(
        withRetry(
          () async {
            callCount++;
            throw const _TestException('non-retryable');
          },
          maxAttempts: 3,
          initialDelay: Duration.zero,
          retryIf: (_) => false,
        ),
        throwsA(isA<_TestException>()),
      );

      expect(callCount, 1);
    });

    test('retries when retryIf returns true', () async {
      var callCount = 0;
      await expectLater(
        withRetry(
          () async {
            callCount++;
            throw const _TestException('retryable');
          },
          maxAttempts: 2,
          initialDelay: Duration.zero,
          retryIf: (_) => true,
        ),
        throwsA(isA<_TestException>()),
      );

      expect(callCount, 2);
    });

    test('respects retryIf to skip retry for specific exception types',
        () async {
      var callCount = 0;
      await expectLater(
        withRetry(
          () async {
            callCount++;
            throw const _TestException('specific');
          },
          maxAttempts: 3,
          initialDelay: Duration.zero,
          retryIf: (e) => e is! _TestException,
        ),
        throwsA(isA<_TestException>()),
      );

      // Should not retry because retryIf returned false for _TestException
      expect(callCount, 1);
    });

    test('succeeds on third attempt when maxAttempts is 3', () async {
      var callCount = 0;
      final result = await withRetry(
        () async {
          callCount++;
          if (callCount < 3) throw const _TestException('transient');
          return 'success';
        },
        maxAttempts: 3,
        initialDelay: Duration.zero,
      );

      expect(result, 'success');
      expect(callCount, 3);
    });
  });
}
