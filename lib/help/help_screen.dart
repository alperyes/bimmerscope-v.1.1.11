import 'package:bmw_app/design/app_palette.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Help')),
    body: ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
          decoration: BoxDecoration(
            color: AppPalette.orange.withValues(alpha: isDark ? .10 : .08),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.timer_outlined,
                    color: AppPalette.orange,
                    size: 25,
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'If it drops after a few minutes',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Before driving, set BimmerScope to Unrestricted battery use in Android settings. This keeps the ENET session active while the screen is off.',
                style: TextStyle(
                  color: AppPalette.secondary(isDark),
                  fontSize: 15,
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
