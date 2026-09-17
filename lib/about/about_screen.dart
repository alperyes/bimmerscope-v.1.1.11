import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/app/build_info.dart';
import 'package:bmw_app/product/product_config.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final secondary = AppPalette.secondary(isDark);
    final edition = ProductConfig.edition == ProductEdition.tune
        ? 'Tune'
        : 'Core';
    return Scaffold(
      appBar: AppBar(title: const Text('About BimmerScope')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Center(
            child: ClipOval(
              child: Image.asset(
                'assets/branding/bimmerscope_icon.png',
                width: 84,
                height: 84,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'BIMMERSCOPE',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _AboutRow(label: 'Version', value: BuildInfo.version),
          _AboutRow(label: 'Build date', value: BuildInfo.date),
          _AboutRow(label: 'Build time', value: BuildInfo.time),
          _AboutRow(label: 'Edition', value: edition),
          _AboutRow(label: 'S55 scope', value: 'F82 · DCT only'),
          _AboutRow(label: 'Current DME', value: 'Bosch MEVD17.2.G'),
          const SizedBox(height: 24),
          _valueCard(isDark: isDark),
          const SizedBox(height: 18),
          Text(
            'Diagnostics, monitoring, logging, flap control, and read-only S55 preparation.',
            style: TextStyle(color: secondary, height: 1.45),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'ECU programming and calibration writing are not enabled in this build.',
            style: TextStyle(color: secondary, height: 1.45),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _valueCard({required bool isDark}) => Container(
    padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
    decoration: BoxDecoration(
      color: AppPalette.surface(isDark),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: AppPalette.separator(isDark).withValues(alpha: .65),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Built for the handover',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        const SizedBox(height: 10),
        _valueRow(
          Icons.speed_rounded,
          'Fast path',
          'Connect, scan, log, and review from one Vehicle launchpad.',
          isDark,
        ),
        _valueRow(
          Icons.fact_check_outlined,
          'Evidence first',
          'VIN, session, timestamp, and ECU provenance travel with exports.',
          isDark,
        ),
        _valueRow(
          Icons.lock_outline_rounded,
          'Read-only by design',
          'No flashing, unlocking, coding, or calibration writes in this build.',
          isDark,
        ),
      ],
    ),
  );

  Widget _valueRow(IconData icon, String title, String body, bool isDark) =>
      Padding(
        padding: const EdgeInsets.only(top: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppPalette.blue),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: TextStyle(
                      color: AppPalette.secondary(isDark),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
      ],
    ),
  );
}
