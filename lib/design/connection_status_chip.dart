import 'package:flutter/material.dart';
import 'app_palette.dart';

class ConnectionStatusChip extends StatelessWidget {
  const ConnectionStatusChip({
    super.key,
    required this.label,
    required this.isDark,
    this.compact = false,
  });
  final String label;
  final bool isDark;
  final bool compact;
  @override
  Widget build(BuildContext context) {
    final normalizedLabel = label.trim().toLowerCase();
    final color =
        normalizedLabel == 'connected' || normalizedLabel == 'monitoring'
        ? AppPalette.green
        : normalizedLabel == 'connecting' ||
              normalizedLabel == 'degraded' ||
              normalizedLabel == 'recovering'
        ? AppPalette.orange
        : AppPalette.red;
    final healthy =
        normalizedLabel == 'connected' || normalizedLabel == 'monitoring';
    if (compact && healthy) {
      return Tooltip(
        message: label,
        child: Semantics(
          container: true,
          label: 'Connection status: $label',
          liveRegion: true,
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
            ),
          ),
        ),
      );
    }
    if (compact) {
      return Semantics(
        container: true,
        label: 'Connection status: $label',
        liveRegion: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: color),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Semantics(
      container: true,
      label: 'Connection status: $label',
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppPalette.surface(isDark),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: color),
              ),
              const SizedBox(width: 7),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
