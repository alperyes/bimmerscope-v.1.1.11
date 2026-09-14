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
        titleMedium: TextStyle(fontWeight: FontWeight.w700, letterSpacing: .1),
        bodyMedium: TextStyle(
          height: 1.35,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        bodySmall: TextStyle(
          height: 1.35,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
        labelSmall: TextStyle(
          fontFeatures: [FontFeature.tabularFigures()],
        ),
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
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      splashFactory: InkSparkle.splashFactory,
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
      cardTheme: CardThemeData(
        elevation: 0,
        color: AppPalette.surface(dark),
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appCardRadius),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppPalette.blue,
          foregroundColor: const Color(0xFF031B3A),
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
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(
            color: dark ? const Color(0xFF303A48) : const Color(0xFFD5DDE8),
          ),
          minimumSize: desktop ? const Size(0, 40) : null,
          padding: desktop
              ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
              : null,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
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
          const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    ),
  );
}
