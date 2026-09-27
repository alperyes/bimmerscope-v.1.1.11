import 'package:flutter/material.dart';

// Hallmark · genre: atmospheric · macrostructure: Workbench · designed-as-app
const appCardRadius = 18.0;
const appSheetRadius = 24.0;
const appCardPadding = EdgeInsets.all(16);
const appTopActionCardHeight = 148.0;

enum AppStatusTone { success, warning, danger, active, neutral }

abstract final class AppPalette {
  // Performance accents sit on neutral black and graphite surfaces.  Green is
  // deliberately reserved for a connected/live state.
  static const blue = Color(0xFF2F8CFF);
  static const blueDeep = Color(0xFF176BDF);
  static const babyBlue = Color(0xFFA8C7FF);
  static const green = Color(0xFF30D158);
  static const red = Color(0xFFFF453A);
  static const orange = Color(0xFFFFB547);

  static Color background(bool dark) =>
      dark ? const Color(0xFF000000) : const Color(0xFFF2F2F7);

  static Color surface(bool dark) =>
      dark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF);

  static Color secondary(bool dark) =>
      dark ? const Color(0xFF98989F) : const Color(0xFF6E6E73);

  static Color separator(bool dark) =>
      dark ? const Color(0xFF38383A) : const Color(0xFFD1D1D6);

  static Color status(AppStatusTone tone, bool dark) => switch (tone) {
    AppStatusTone.success => green,
    AppStatusTone.warning => orange,
    AppStatusTone.danger => red,
    AppStatusTone.active => blue,
    AppStatusTone.neutral => secondary(dark),
  };

  static IconData statusIcon(AppStatusTone tone) => switch (tone) {
    AppStatusTone.success => Icons.check_rounded,
    AppStatusTone.warning => Icons.priority_high_rounded,
    AppStatusTone.danger => Icons.close_rounded,
    AppStatusTone.active => Icons.sync_rounded,
    AppStatusTone.neutral => Icons.remove_rounded,
  };

  static AppStatusTone connectionTone(String label) {
    return switch (label.trim().toLowerCase()) {
      'connected' || 'monitoring' => AppStatusTone.success,
      'connecting' ||
      'scanning' ||
      'searching' ||
      'identifying' ||
      'discovering' ||
      'reconnecting' => AppStatusTone.active,
      'degraded' || 'recovering' => AppStatusTone.warning,
      'error' || 'failed' => AppStatusTone.danger,
      _ => AppStatusTone.neutral,
    };
  }
}
