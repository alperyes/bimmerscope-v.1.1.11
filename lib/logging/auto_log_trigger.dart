enum AutoLogDecision { none, start, stop }

/// Decides when an opt-in automatic pull log should start or stop.
/// It uses a lower release threshold to avoid stopping during brief throttle
/// modulation, and requires three seconds below that threshold before stop.
class AutoLogTrigger {
  DateTime? _releasedAt;

  AutoLogDecision observe({
    required bool enabled,
    required bool sessionActive,
    required bool isRecording,
    required bool automaticRecording,
    required double throttlePercent,
    required double startThreshold,
    required DateTime now,
    Duration releaseDelay = const Duration(seconds: 3),
  }) {
    if (!enabled || !sessionActive) {
      reset();
      return AutoLogDecision.none;
    }
    if (throttlePercent >= startThreshold) {
      _releasedAt = null;
      return isRecording ? AutoLogDecision.none : AutoLogDecision.start;
    }
    if (!isRecording ||
        !automaticRecording ||
        throttlePercent > startThreshold * .5) {
      _releasedAt = null;
      return AutoLogDecision.none;
    }
    _releasedAt ??= now;
    if (now.difference(_releasedAt!) < releaseDelay) {
      return AutoLogDecision.none;
    }
    _releasedAt = null;
    return AutoLogDecision.stop;
  }

  void reset() => _releasedAt = null;
}
