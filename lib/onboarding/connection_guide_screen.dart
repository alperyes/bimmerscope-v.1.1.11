import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:lottie/lottie.dart';

class ConnectionGuideScreen extends StatefulWidget {
  const ConnectionGuideScreen({
    super.key,
    required this.isDark,
    required this.onDone,
    this.firstLaunch = false,
  });

  final bool isDark;
  final Future<void> Function() onDone;
  final bool firstLaunch;

  @override
  State<ConnectionGuideScreen> createState() => _ConnectionGuideScreenState();
}

class _ConnectionGuideScreenState extends State<ConnectionGuideScreen> {
  int page = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: ColoredBox(
      color: AppPalette.background(widget.isDark),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _progressRail(),
                    SizedBox(height: page == 0 ? 88 : 32),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      child: page == 0 ? overview() : stepPage(page),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: AppPalette.surface(widget.isDark).withValues(alpha: .94),
                border: Border(
                  top: BorderSide(
                    color: widget.isDark
                        ? AppPalette.separator(true)
                        : AppPalette.separator(false),
                  ),
                ),
              ),
              child: Column(
                children: [
                  FilledButton.icon(
                    onPressed: () async {
                      HapticFeedback.mediumImpact();
                      if (page < 4) {
                        setState(() => page++);
                      } else {
                        await widget.onDone();
                      }
                    },
                    icon: Icon(
                      page < 4
                          ? Icons.arrow_forward_rounded
                          : Icons.check_rounded,
                    ),
                    label: Text(page < 4 ? 'Next' : 'Finish setup'),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      backgroundColor: AppPalette.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: () async {
                      HapticFeedback.selectionClick();
                      if (widget.firstLaunch) {
                        await widget.onDone();
                      } else if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      widget.firstLaunch ? 'Skip setup' : 'Skip guide',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget overview() => Column(
    children: [
      hero(),
      const SizedBox(height: 28),
      infoCard(
        icon: Icons.directions_car_filled_rounded,
        color: AppPalette.blue,
        title: 'Compatibility',
        body: 'BMW F-series (2012–2019)',
      ),
      const SizedBox(height: 12),
      infoCard(
        icon: Icons.cable_rounded,
        color: AppPalette.babyBlue,
        title: 'Supported adapters',
        body: 'Direct ENET cable only.',
      ),
      const SizedBox(height: 22),
      setupSummary(),
      const SizedBox(height: 14),
      troubleshootingCard(),
      const SizedBox(height: 18),
      safetyCard(),
    ],
  );

  Widget setupSummary() => Container(
    padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
    decoration: BoxDecoration(
      color: AppPalette.blue.withValues(alpha: widget.isDark ? .10 : .07),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppPalette.blue.withValues(alpha: .32)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.cable_rounded, color: AppPalette.blue, size: 25),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'The quick path',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
            Text(
              '4 steps',
              style: TextStyle(
                color: AppPalette.secondary(widget.isDark),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Cable in → ignition on → Ethernet enabled → Find vehicle. BimmerScope reads the car; it does not code or flash it.',
          style: TextStyle(
            color: AppPalette.secondary(widget.isDark),
            fontSize: 15,
            height: 1.35,
          ),
        ),
      ],
    ),
  );

  Widget troubleshootingCard() => Container(
    padding: const EdgeInsets.fromLTRB(20, 19, 20, 18),
    decoration: BoxDecoration(
      color: AppPalette.orange.withValues(alpha: widget.isDark ? .10 : .08),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppPalette.orange.withValues(alpha: .38)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.timer_outlined, color: AppPalette.orange, size: 25),
            SizedBox(width: 14),
            Text(
              'If it drops after a few minutes',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Before driving, set BimmerScope to Unrestricted battery use in Android settings. This keeps the ENET session active while the screen is off.',
          style: TextStyle(
            color: AppPalette.secondary(widget.isDark),
            fontSize: 15,
            height: 1.35,
          ),
        ),
      ],
    ),
  );

  Widget stepPage(int index) {
    const titles = [
      'Plug in the OBD2 adapter',
      'Switch the ignition on',
      'Join the ENET network',
      'Find the vehicle',
    ];
    const bodies = [
      'Find the port in the driver footwell, then push the OBD2 end in until it is fully seated. Connect the ENET end to the phone or adapter.',
      'Press the Start/Stop button without pressing the brake or clutch. The dash should wake up; leave the engine off.',
      'Turn off Wi‑Fi and mobile data. On Android, enable Share via Ethernet / Ethernet tethering. On POCO/Xiaomi: Settings → Portable hotspot → Share via Ethernet.',
      'Return to Vehicle and tap Connect. Wait for Identifying to finish before opening Monitor or Diagnostics.',
    ];
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          'STEP $index OF 4',
          style: const TextStyle(
            color: AppPalette.blue,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 16),
        step(index, titles[index - 1], bodies[index - 1], last: true),
        const SizedBox(height: 24),
        Center(child: _stepIllustration(index)),
        if (index == 4) ...[const SizedBox(height: 20), safetyCard()],
      ],
    );
  }

  Widget _stepIllustration(int index) {
    if (index == 1) {
      return Column(
        children: [
          const SizedBox(width: 328, height: 292, child: _ObdVectorAnimation()),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _connectionLabel('OBD2 ADAPTER', AppPalette.blue),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: AppPalette.blue,
                ),
              ),
              _connectionLabel('OBD2 PORT', const Color(0xFF7A8597)),
            ],
          ),
        ],
      );
    }
    final animation = _guideAnimation(index);

    return SizedBox(width: 300, height: 300, child: animation);
  }

  Widget _guideAnimation(int index) {
    final asset = [
      'connect_enet_clear.json',
      'start_stop_ignition.json',
      'enet_network.json',
      'vehicle_discovery.json',
    ][index - 1];

    return FutureBuilder<String>(
      future: rootBundle.loadString('assets/animations/$asset'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        // The original ENET file contains one stray character before the JSON.
        // Strip it defensively so the guide remains renderable with old builds.
        final json = snapshot.data!.trimLeft();
        final cleanJson = json.startsWith('{') ? json : json.substring(1);
        final lottie = Lottie.memory(
          Uint8List.fromList(utf8.encode(cleanJson)),
          repeat: true,
          fit: BoxFit.contain,
          alignment: Alignment.center,
          delegates: LottieDelegates(
            values: [
              ValueDelegate.color(const [
                '**',
                'blue stroke',
              ], value: AppPalette.blue),
              ValueDelegate.color(const [
                '**',
                'blue light',
              ], value: AppPalette.blue),
            ],
          ),
        );
        if (asset != 'start_stop_ignition.json') return lottie;
        return Stack(
          alignment: Alignment.center,
          children: [
            lottie,
            const IgnorePointer(
              child: Text(
                'START\nSTOP\nENGINE',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.12,
                  letterSpacing: .4,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _connectionLabel(String label, Color color) => Text(
    label,
    style: TextStyle(
      color: color,
      fontSize: 9,
      fontWeight: FontWeight.w800,
      letterSpacing: .7,
    ),
  );
  /*
  Widget _legacyStepIllustration(int index) => TweenAnimationBuilder<double>(
    tween: Tween(begin: 0, end: 1),
    duration: const Duration(milliseconds: 900),
    curve: Curves.easeInOut,
    onEnd: () {
      if (mounted) setState(() {});
    },
    builder: (context, value, child) => Transform.translate(
      offset: Offset(index == 1 ? 18 * (1 - value) : 0, 0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 132,
        height: 132,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppPalette.blue.withValues(alpha: .10 + value * .08),
          border: Border.all(color: AppPalette.blue.withValues(alpha: .35)),
        ),
        child: Icon(
          [
            Icons.cable_rounded,
            Icons.power_settings_new_rounded,
            Icons.wifi_rounded,
            Icons.directions_car_filled_rounded,
          ][index - 1],
          size: 58,
          color: AppPalette.blue,
        ),
      ),
    ),
  );
*/

  Widget _progressRail() => LayoutBuilder(
    builder: (context, constraints) => Container(
      height: 6,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.isDark
            ? const Color(0xFF25272D)
            : const Color(0xFFDCE0E6),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          width: constraints.maxWidth * ((page + 1) / 5),
          decoration: BoxDecoration(
            color: AppPalette.blue,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    ),
  );

  Widget hero() => Center(
    child: Column(
      children: [
        Container(
          width: 132,
          height: 132,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [AppPalette.blue, AppPalette.blueDeep],
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.blue.withValues(alpha: .33),
                blurRadius: 34,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset('assets/branding/bimmerscope_icon.png'),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          'BIMMERSCOPE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Live telemetry, diagnostics, and logging',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF7A8597),
            fontSize: 15,
            height: 1.45,
          ),
        ),
      ],
    ),
  );

  Widget sectionTitle(String title, String subtitle) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          height: 1.05,
          fontWeight: FontWeight.w800,
          letterSpacing: -.5,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        subtitle,
        style: const TextStyle(
          color: Color(0xFF7A8597),
          fontSize: 12,
          height: 1.4,
        ),
      ),
    ],
  );

  Widget infoCard({
    required IconData icon,
    required Color color,
    required String title,
    required String body,
  }) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: widget.isDark ? const Color(0xFF121620) : Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: widget.isDark
            ? const Color(0xFF242B39)
            : const Color(0xFFE3E8F1),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Icon(icon, color: color, size: 29),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                body,
                style: const TextStyle(
                  color: Color(0xFF7A8597),
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget step(int number, String title, String body, {bool last = false}) =>
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 36,
              child: Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppPalette.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (!last)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: AppPalette.blue.withValues(alpha: .2),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: last ? 0 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      body,
                      style: const TextStyle(
                        color: Color(0xFF7A8597),
                        fontSize: 11,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget safetyCard() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFFFB547).withValues(alpha: .1),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB547)),
        SizedBox(width: 11),
        Expanded(
          child: Text(
            'Configure the dashboard before driving. Keep your attention on the road, mount the device securely and never run diagnostics while the vehicle is moving.',
            style: TextStyle(fontSize: 11, height: 1.45),
          ),
        ),
      ],
    ),
  );
}

class _ObdVectorAnimation extends StatefulWidget {
  const _ObdVectorAnimation();
  @override
  State<_ObdVectorAnimation> createState() => _ObdVectorAnimationState();
}

class _ObdVectorAnimationState extends State<_ObdVectorAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (_, child) => CustomPaint(
      painter: _ObdVectorPainter(controller.value),
      size: Size.infinite,
    ),
  );
}

class _ObdVectorPainter extends CustomPainter {
  _ObdVectorPainter(this.progress);
  final double progress;
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 328;
    canvas.scale(s, s);
    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()..style = PaintingStyle.fill;
    // Soft dashboard silhouette, inspired by the actual under-dash view.
    fill.color = const Color(0xffedf1f4);
    canvas.drawPath(
      Path()
        ..moveTo(0, 45)
        ..quadraticBezierTo(115, 8, 328, 35)
        ..lineTo(328, 292)
        ..lineTo(0, 292)
        ..close(),
      fill,
    );
    p.color = const Color(0xffcbd2d8);
    p.strokeWidth = 2;
    canvas.drawPath(
      Path()
        ..moveTo(0, 75)
        ..quadraticBezierTo(110, 28, 328, 58),
      p,
    );
    // Recess and clearly defined OBD socket.
    fill.color = const Color(0xffdce2e6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(35, 104, 258, 127),
        const Radius.circular(28),
      ),
      fill,
    );
    p.color = const Color(0xffb7c0c7);
    p.strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(35, 104, 258, 127),
        const Radius.circular(28),
      ),
      p,
    );
    fill.color = const Color(0xfffafbfc);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(75, 139, 178, 65),
        const Radius.circular(12),
      ),
      fill,
    );
    p.color = const Color(0xff8d989f);
    p.strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(75, 139, 178, 65),
        const Radius.circular(12),
      ),
      p,
    );
    for (var i = 0; i < 8; i++) {
      fill.color = const Color(0xff9ca8af);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(90 + i * 21, 151, 11, 7),
          const Radius.circular(2),
        ),
        fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(90 + i * 21, 180, 11, 7),
          const Radius.circular(2),
        ),
        fill,
      );
    }
    // Adapter moves along a short path toward the socket.
    final t = Curves.easeInOut.transform(progress);
    final x = 63 + 82 * t;
    final y = 70 + 38 * t;
    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(-.08 * (1 - t));
    fill.color = const Color(0xff4b555d);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-42, -24, 84, 48),
        const Radius.circular(9),
      ),
      fill,
    );
    p.color = const Color(0xff263038);
    p.strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-42, -24, 84, 48),
        const Radius.circular(9),
      ),
      p,
    );
    fill.color = const Color(0xffeef2f4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-33, -16, 57, 28),
        const Radius.circular(5),
      ),
      fill,
    );
    p.color = const Color(0xffaab4ba);
    p.strokeWidth = 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-33, -16, 57, 28),
        const Radius.circular(5),
      ),
      p,
    );
    p.color = const Color(0xff607078);
    p.strokeWidth = 2;
    canvas.drawLine(const Offset(25, -14), const Offset(39, -10), p);
    canvas.drawLine(const Offset(25, -5), const Offset(39, -1), p);
    canvas.drawLine(const Offset(25, 4), const Offset(39, 8), p);
    canvas.restore();
    if (progress > .94) {
      p.color = AppPalette.blue.withValues(alpha: .65);
      p.strokeWidth = 3;
      canvas.drawCircle(const Offset(164, 171), 55 + (progress - .94) * 180, p);
    }
  }

  @override
  bool shouldRepaint(covariant _ObdVectorPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
