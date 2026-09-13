import 'package:bmw_app/design/app_palette.dart';
import 'package:flutter/material.dart';

/// Plain-language explanation of the Tune preparation workflow.
///
/// The guide deliberately distinguishes review and preparation from ECU
/// programming so a new owner always knows what the app can do today.
class TuneGuideScreen extends StatelessWidget {
  const TuneGuideScreen({super.key, required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final muted = AppPalette.secondary(isDark);
    return Scaffold(
      backgroundColor: AppPalette.background(isDark),
      appBar: AppBar(
        title: const Text('Tune workspace'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text(
            'Prepare with confidence',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -.7,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'BimmerScope turns a vehicle session into clear evidence your tuner can review. It keeps every file, log, and identity read tied to the right car.',
            style: TextStyle(color: muted, height: 1.45),
          ),
          const SizedBox(height: 18),
          _statusBanner(isDark: isDark),
          const SizedBox(height: 22),
          Text(
            'The five-step workflow',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const _GuideStep(
            number: '1',
            title: 'Identify the car',
            body:
                'Connect and confirm the VIN, engine, transmission, and DME identity. A connected cable alone is not proof of tune compatibility.',
          ),
          const _GuideStep(
            number: '2',
            title: 'Protect the stock file',
            body:
                'Import a known stock file. BimmerScope keeps timestamped, hash-traceable copies; never replace your only original.',
          ),
          const _GuideStep(
            number: '3',
            title: 'Capture useful logs',
            body:
                'Choose a small channel set, record a clean pull interval, and review gaps or stale telemetry before sharing.',
          ),
          const _GuideStep(
            number: '4',
            title: 'Review, do not edit',
            body:
                'Compare file identity and metadata read-only. The app never changes calibration bytes or installs a package.',
          ),
          const _GuideStep(
            number: '5',
            title: 'Send a tuner package',
            body:
                'Bundle vehicle evidence, modifications, selected logs, and backup status into one VIN-scoped request your tuner can reopen.',
          ),
          const SizedBox(height: 10),
          _speedTips(isDark: isDark),
          const SizedBox(height: 12),
          _safetyNote(isDark: isDark),
        ],
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  const _GuideStep({
    required this.number,
    required this.title,
    required this.body,
  });
  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppPalette.blue.withValues(alpha: .15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppPalette.blue.withValues(alpha: .35)),
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: AppPalette.blue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(
                body,
                style: TextStyle(
                  color: AppPalette.secondary(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                  height: 1.38,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _statusBanner({required bool isDark}) => Container(
  padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
  decoration: BoxDecoration(
    color: AppPalette.blue.withValues(alpha: isDark ? .13 : .08),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: AppPalette.blue.withValues(alpha: .24)),
  ),
  child: const Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.fact_check_outlined, color: AppPalette.blue, size: 21),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          'Today: identify → back up → log → review → share',
          style: TextStyle(fontWeight: FontWeight.w800, height: 1.3),
        ),
      ),
    ],
  ),
);

Widget _speedTips({required bool isDark}) {
  final muted = AppPalette.secondary(isDark);
  return Container(
    padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
    decoration: BoxDecoration(
      color: AppPalette.surface(isDark),
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bolt_rounded, color: AppPalette.orange, size: 20),
            SizedBox(width: 9),
            Text(
              'Faster reviews',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Use the same four channels for repeat pulls, keep the phone awake while logging, and attach only the cleanest interval to a request.',
          style: TextStyle(color: muted, height: 1.38),
        ),
      ],
    ),
  );
}

Widget _safetyNote({required bool isDark}) => Container(
  padding: const EdgeInsets.fromLTRB(15, 14, 15, 14),
  decoration: BoxDecoration(
    color: AppPalette.orange.withValues(alpha: .10),
    borderRadius: BorderRadius.circular(18),
    border: Border.all(color: AppPalette.orange.withValues(alpha: .22)),
  ),
  child: const Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(Icons.lock_outline_rounded, color: AppPalette.orange, size: 20),
      SizedBox(width: 10),
      Expanded(
        child: Text(
          'Calibration writing, unlocking, flashing, and package installation are unavailable in this build. Review evidence with a qualified tuner before making changes.',
          style: TextStyle(height: 1.38),
        ),
      ),
    ],
  ),
);
