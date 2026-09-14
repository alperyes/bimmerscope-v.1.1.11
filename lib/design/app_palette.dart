import 'package:flutter/material.dart';

// Hallmark · genre: atmospheric · macrostructure: Workbench · designed-as-app
const appCardRadius = 18.0;
const appSheetRadius = 24.0;
const appCardPadding = EdgeInsets.all(16);

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
}
