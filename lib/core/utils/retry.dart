import 'dart:async';
import 'dart:math' as math;

/// Executes [operation] with automatic retries on transient failures.
///
/// The operation is attempted up to [maxAttempts] times total. Between each
/// attempt the call waits for an exponentially increasing delay starting at
/// [initialDelay], capped at [maxDelay].
///
/// If [retryIf] is provided it is called with each caught exception; when it
/// returns `false` the exception is rethrown immediately without any further
/// retries.
///
/// When all attempts are exhausted the exception from the last attempt is
/// rethrown.
Future<T> withRetry<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(milliseconds: 500),
  Duration maxDelay = const Duration(seconds: 8),
  bool Function(Exception)? retryIf,
}) async {
  assert(maxAttempts >= 1, 'maxAttempts must be at least 1');

  var attempt = 0;
  while (true) {
    try {
      return await operation();
    } on Exception catch (error) {
      attempt++;

      if (attempt >= maxAttempts) rethrow;

      if (retryIf != null && !retryIf(error)) rethrow;

      final delayMs = math.min(
        initialDelay.inMilliseconds * math.pow(2, attempt - 1).toInt(),
        maxDelay.inMilliseconds,
      );
      await Future<void>.delayed(Duration(milliseconds: delayMs));
    }
  }
}
