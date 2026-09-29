import 'package:bmw_app/dashboard/dashboard_screen.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/onboarding/connection_guide_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmwEnetApp extends StatefulWidget {
  const BmwEnetApp({super.key, this.previewMode = false});
  final bool previewMode;

  @override
  State<BmwEnetApp> createState() => _BmwEnetAppState();
}

class _BmwEnetAppState extends State<BmwEnetApp> {
  ThemeMode mode = ThemeMode.dark;
  bool onboardingLoaded = false;
  bool onboardingComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.previewMode) {
      onboardingLoaded = true;
      onboardingComplete = true;
    } else {
      loadOnboarding();
    }
  }

  Future<void> loadOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      mode = preferences.getString('theme_mode') == 'light'
          ? ThemeMode.light
          : ThemeMode.dark;
      onboardingComplete = preferences.getBool('onboarding_complete') ?? false;
      onboardingLoaded = true;
    });
  }

  Future<void> completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('onboarding_complete', true);
    if (mounted) setState(() => onboardingComplete = true);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'BimmerScope',
    themeMode: mode,
    themeAnimationDuration: const Duration(milliseconds: 250),
    themeAnimationCurve: Curves.easeOut,
    theme: _theme(Brightness.light),
    darkTheme: _theme(Brightness.dark),
    home: !onboardingLoaded
        ? _LoadingScreen(isDark: mode == ThemeMode.dark)
        : onboardingComplete
        ? DashboardScreen(
            previewMode: widget.previewMode,
            isDark: mode == ThemeMode.dark,
            onToggleTheme: toggleTheme,
          )
        : ConnectionGuideScreen(
            isDark: mode == ThemeMode.dark,
            firstLaunch: true,
            onDone: completeOnboarding,
          ),
  );

  void toggleTheme() {
    final next = mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    setState(() => mode = next);
    SharedPreferences.getInstance().then(
      (preferences) => preferences.setString(
        'theme_mode',
        next == ThemeMode.light ? 'light' : 'dark',
      ),
    );
  }

  ThemeData _theme(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final desktop = switch (defaultTargetPlatform) {
      TargetPlatform.windows ||
      TargetPlatform.macOS ||
      TargetPlatform.linux => true,
      _ => false,
    };
    final scheme = ColorScheme.fromSeed(
      seedColor: AppPalette.blue,
      brightness: brightness,
      surface: AppPalette.surface(dark),
      error: AppPalette.red,
    ).copyWith(primary: AppPalette.blue, onPrimary: const Color(0xFF031B3A));
    return ThemeData(
      brightness: brightness,
      fontFamily: 'Instrument Sans',
      scaffoldBackgroundColor: AppPalette.background(dark),
      colorScheme: scheme,
      useMaterial3: true,
      visualDensity: desktop ? VisualDensity.compact : VisualDensity.standard,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          height: 1.05,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
          height: 1.12,
        ),
        titleMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: .1),
        bodyLarge: TextStyle(
          height: 1.4,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        bodyMedium: TextStyle(
          height: 1.35,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        bodySmall: TextStyle(
          height: 1.35,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w700,
          letterSpacing: .1,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        labelSmall: TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
      ),
      navigationBarTheme: NavigationBarThemeData(
        // Material's label layout needs the full mobile navigation-bar
        // height. A shorter bar overflows on compact device viewports.
        height: desktop ? 64 : 80,
        elevation: 0,
        backgroundColor: dark
            ? const Color(0xF21C1C1E)
            : const Color(0xF2FFFFFF),
        indicatorColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 23,
            color: selected
                ? AppPalette.blue
                : dark
                ? const Color(0xFF8E8E93)
                : const Color(0xFF6E6E73),
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? AppPalette.blue
                : dark
                ? const Color(0xFF8E8E93)
                : const Color(0xFF6E6E73),
          );
        }),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: WidgetStatePropertyAll(desktop ? 7 : 4),
        radius: const Radius.circular(99),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) {
            return AppPalette.blue.withValues(alpha: .78);
          }
          if (states.contains(WidgetState.hovered)) {
            return AppPalette.blue.withValues(alpha: .58);
          }
          return (dark ? Colors.white : Colors.black).withValues(alpha: .28);
        }),
        trackColor: WidgetStatePropertyAll(
          (dark ? Colors.white : Colors.black).withValues(alpha: .04),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppPalette.background(dark),
        foregroundColor: dark ? Colors.white : const Color(0xFF172033),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: dark ? Colors.white : const Color(0xFF172033),
          fontFamily: 'Instrument Sans',
          fontSize: 17,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(
          color: dark ? const Color(0xFFD5D7DC) : const Color(0xFF3B4657),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      // A restrained ripple keeps touch feedback legible without adding
      // decorative sparkle to a technical, data-dense workspace.
      splashFactory: InkRipple.splashFactory,
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: dark
            ? const Color(0xF211151B)
            : const Color(0xF2FFFFFF),
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: dark ? const Color(0xFF111214) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrimColor: Colors.black.withValues(alpha: dark ? .62 : .34),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(24)),
        ),
        width: 320,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppPalette.surface(dark),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appCardRadius),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppPalette.separator(dark).withValues(alpha: .72),
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: dark ? const Color(0xFF111214) : const Color(0xFFF7F8FA),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: dark ? const Color(0xFF303238) : const Color(0xFFD7DCE5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: dark ? const Color(0xFF303238) : const Color(0xFFD7DCE5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.blue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppPalette.red, width: 1.5),
        ),
        hintStyle: TextStyle(
          color: dark ? const Color(0xFF858991) : const Color(0xFF687386),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: dark ? const Color(0xFF1C1C1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appSheetRadius),
        ),
        titleTextStyle: TextStyle(
          color: dark ? Colors.white : const Color(0xFF172033),
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -.2,
        ),
        contentTextStyle: TextStyle(
          color: dark ? const Color(0xFFD5D7DC) : const Color(0xFF4C5668),
          height: 1.4,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: dark
            ? const Color(0xFF2B2D31)
            : const Color(0xFF20242B),
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: dark ? const Color(0xFF1C1C1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: dark ? const Color(0xFF303238) : const Color(0xFFE0E3E8),
          ),
        ),
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(
            color: dark ? const Color(0xFFE5E6EA) : const Color(0xFF172033),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: dark ? const Color(0xFF2B2D31) : const Color(0xFF20242B),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        waitDuration: const Duration(milliseconds: 450),
        showDuration: const Duration(seconds: 4),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppPalette.blue,
        linearTrackColor: dark
            ? const Color(0xFF2A2D33)
            : const Color(0xFFDDE5F2),
        circularTrackColor: dark
            ? const Color(0xFF2A2D33)
            : const Color(0xFFDDE5F2),
        linearMinHeight: 3,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppPalette.blue;
          return dark ? const Color(0xFFB8BBC3) : const Color(0xFF687386);
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppPalette.blue.withValues(alpha: dark ? .42 : .28);
          }
          return dark ? const Color(0xFF383A40) : const Color(0xFFD9DDE4);
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppPalette.blue.withValues(alpha: .62);
          }
          return dark ? const Color(0xFF4A4D54) : const Color(0xFFC3C9D3);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return dark ? const Color(0xFF383A40) : const Color(0xFFD9DDE4);
          }
          if (states.contains(WidgetState.selected)) return AppPalette.blue;
          return Colors.transparent;
        }),
        checkColor: const WidgetStatePropertyAll(Color(0xFF031B3A)),
        side: BorderSide(
          color: dark ? const Color(0xFF62656D) : const Color(0xFF8A94A3),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return dark ? const Color(0xFF62656D) : const Color(0xFF8A94A3);
          }
          return states.contains(WidgetState.selected)
              ? AppPalette.blue
              : (dark ? const Color(0xFF62656D) : const Color(0xFF8A94A3));
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppPalette.blue,
        inactiveTrackColor: dark
            ? const Color(0xFF383A40)
            : const Color(0xFFD9DDE4),
        thumbColor: AppPalette.blue,
        overlayColor: AppPalette.blue.withValues(alpha: .14),
        valueIndicatorColor: dark
            ? const Color(0xFF2B2D31)
            : const Color(0xFF20242B),
        valueIndicatorTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return dark ? Colors.white : const Color(0xFF172033);
            }
            return dark ? const Color(0xFFB8BBC3) : const Color(0xFF566174);
          }),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppPalette.blue.withValues(alpha: dark ? .22 : .14);
            }
            return Colors.transparent;
          }),
          side: WidgetStateProperty.resolveWith((states) {
            return BorderSide(
              color: states.contains(WidgetState.selected)
                  ? AppPalette.blue.withValues(alpha: .62)
                  : (dark ? const Color(0xFF3A3C43) : const Color(0xFFD7DCE5)),
            );
          }),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: dark
            ? const Color(0xFF222429)
            : const Color(0xFFF0F2F5),
        selectedColor: AppPalette.blue.withValues(alpha: dark ? .22 : .14),
        side: BorderSide(
          color: dark ? const Color(0xFF363940) : const Color(0xFFD7DCE5),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        labelStyle: TextStyle(
          color: dark ? const Color(0xFFD5D7DC) : const Color(0xFF3B4657),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: TextStyle(
          color: dark ? const Color(0xFFB7BAC2) : const Color(0xFF566174),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style:
            FilledButton.styleFrom(
              backgroundColor: AppPalette.blue,
              foregroundColor: const Color(0xFF031B3A),
              disabledBackgroundColor: dark
                  ? const Color(0xFF282A2F)
                  : const Color(0xFFE2E5EA),
              disabledForegroundColor: dark
                  ? const Color(0xFF858991)
                  : const Color(0xFF8A94A3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              minimumSize: desktop ? const Size(0, 40) : null,
              padding: desktop
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                  : null,
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: .1,
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.black.withValues(alpha: .12);
                }
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white.withValues(alpha: .08);
                }
                return null;
              }),
            ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(
                color: dark ? const Color(0xFF303A48) : const Color(0xFFD5DDE8),
              ),
              disabledForegroundColor: dark
                  ? const Color(0xFF858991)
                  : const Color(0xFF8A94A3),
              minimumSize: desktop ? const Size(0, 40) : null,
              padding: desktop
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                  : null,
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
            ).copyWith(
              side: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return BorderSide(
                    color: dark
                        ? const Color(0xFF25272B)
                        : const Color(0xFFE1E4E9),
                  );
                }
                return BorderSide(
                  color: dark
                      ? const Color(0xFF303A48)
                      : const Color(0xFFD5DDE8),
                );
              }),
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppPalette.blue.withValues(alpha: .12);
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppPalette.blue.withValues(alpha: .06);
                }
                return null;
              }),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style:
            TextButton.styleFrom(
              foregroundColor: AppPalette.blue,
              minimumSize: const Size(0, 44),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              textStyle: const TextStyle(fontWeight: FontWeight.w700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppPalette.blue.withValues(alpha: .14);
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppPalette.blue.withValues(alpha: .07);
                }
                return null;
              }),
            ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(40, 40),
          padding: const EdgeInsets.all(9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        minVerticalPadding: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: TextStyle(
          color: dark ? Colors.white : const Color(0xFF172033),
          fontFamily: 'Instrument Sans',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        subtitleTextStyle: TextStyle(
          color: dark ? const Color(0xFF9DA8B8) : const Color(0xFF58677B),
          fontFamily: 'Instrument Sans',
          fontSize: 12,
          height: 1.35,
        ),
      ),
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: isDark ? Colors.black : const Color(0xFFF5F7FB),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/branding/bimmerscope_icon.png',
            width: 96,
            height: 96,
          ),
          const SizedBox(height: 22),
          Text(
            'BimmerScope',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF172033),
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: .2,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Preparing workspace',
            style: TextStyle(
              color: isDark ? const Color(0xFF9DA8B8) : const Color(0xFF58677B),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 150,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: const LinearProgressIndicator(minHeight: 3),
            ),
          ),
        ],
      ),
    ),
  );
}
