import 'package:bmw_app/logging/auto_log_trigger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('starts at threshold and stops after sustained release', () {
    final trigger = AutoLogTrigger();
    final started = DateTime(2026, 9, 14, 12);
    AutoLogDecision observe({
      required double throttle,
      required DateTime now,
      bool recording = false,
      bool automatic = false,
    }) => trigger.observe(
      enabled: true,
      sessionActive: true,
      isRecording: recording,
      automaticRecording: automatic,
      throttlePercent: throttle,
      startThreshold: 70,
      now: now,
    );

    expect(observe(throttle: 69.9, now: started), AutoLogDecision.none);
    expect(observe(throttle: 70, now: started), AutoLogDecision.start);
    expect(
      observe(
        throttle: 40,
        now: started.add(const Duration(seconds: 1)),
        recording: true,
        automatic: true,
      ),
      AutoLogDecision.none,
    );
    expect(
      observe(
        throttle: 34,
        now: started.add(const Duration(seconds: 2)),
        recording: true,
        automatic: true,
      ),
      AutoLogDecision.none,
    );
    expect(
      observe(
        throttle: 34,
        now: started.add(const Duration(seconds: 5)),
        recording: true,
        automatic: true,
      ),
      AutoLogDecision.stop,
    );
  });

  test('does not stop manual recording or retain a stale release timer', () {
    final trigger = AutoLogTrigger();
    final now = DateTime(2026, 9, 14, 12);
    expect(
      trigger.observe(
        enabled: true,
        sessionActive: true,
        isRecording: true,
        automaticRecording: false,
        throttlePercent: 0,
        startThreshold: 70,
        now: now,
      ),
      AutoLogDecision.none,
    );
    expect(
      trigger.observe(
        enabled: false,
        sessionActive: true,
        isRecording: true,
        automaticRecording: true,
        throttlePercent: 0,
        startThreshold: 70,
        now: now.add(const Duration(seconds: 10)),
      ),
      AutoLogDecision.none,
    );
  });
}
