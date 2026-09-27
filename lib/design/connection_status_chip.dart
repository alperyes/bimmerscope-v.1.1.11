import 'package:flutter/material.dart';
import 'app_palette.dart';

class ConnectionStatusChip extends StatelessWidget {
  const ConnectionStatusChip({
    super.key,
    required this.label,
    required this.isDark,
    this.compact = false,
    this.iconOnly = false,
  });
  final String label;
  final bool isDark;
  final bool compact;
  final bool iconOnly;
  @override
  Widget build(BuildContext context) {
    final tone = AppPalette.connectionTone(label);
    final color = AppPalette.status(tone, isDark);
    final icon = AppPalette.statusIcon(tone);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final animating = tone == AppStatusTone.active && !reduceMotion;
    final iconTransition = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 180);
    if (iconOnly) {
      final connected = label.trim().toLowerCase() == 'connected';
      final indicatorLabel = connected ? 'Connected' : 'Not connected';
      return Tooltip(
        message: indicatorLabel,
        child: Semantics(
          container: true,
          label: 'Connection status: $indicatorLabel',
          liveRegion: true,
          child: SizedBox.square(
            dimension: 24,
            child: Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: connected ? AppPalette.green : AppPalette.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (connected ? AppPalette.green : AppPalette.red)
                          .withValues(alpha: .22),
                      blurRadius: 0,
                      spreadRadius: 7,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (compact) {
      return Tooltip(
        message: label,
        child: Semantics(
          container: true,
          label: 'Connection status: $label',
          liveRegion: true,
          child: Container(
            constraints: const BoxConstraints(minHeight: 32, maxWidth: 148),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? .18 : .11),
              border: Border.all(
                color: color.withValues(alpha: isDark ? .72 : .55),
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .1,
                    ),
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
          color: color.withValues(alpha: isDark ? .10 : .07),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: color.withValues(alpha: isDark ? .52 : .38),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: iconTransition,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: AnimatedRotation(
                  key: ValueKey(icon),
                  turns: animating ? .25 : 0,
                  duration: reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  child: Icon(icon, size: 14, color: color),
                ),
              ),
              const SizedBox(width: 7),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
