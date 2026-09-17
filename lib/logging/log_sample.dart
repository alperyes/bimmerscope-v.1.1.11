/// A numeric log sample with its acquisition position on the session timeline.
class LogSample {
  const LogSample({required this.elapsedMs, required this.value});

  final int elapsedMs;
  final double value;
}
