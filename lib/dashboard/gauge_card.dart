import 'dart:math' as math;

import 'package:bmw_app/src/rust/api/vehicle.dart';
import 'package:flutter/material.dart';
import 'package:bmw_app/design/app_palette.dart';
import 'package:bmw_app/design/gauge_tokens.dart';

const _gaugeCardHorizontal = gaugeCardHorizontal;
const _gaugeCardTop = gaugeCardTop;
const _gaugeCardBottom = gaugeCardBottom;
const _gaugeSectionGap = gaugeSectionGap;
const _compactDialRadiusWidth = compactDialRadiusWidth;
const _compactDialRadiusHeight = compactDialRadiusHeight;
const _compactDialCenterY = compactDialCenterY;
const _fullscreenDialRadiusWidth = fullscreenDialRadiusWidth;
const _fullscreenDialRadiusHeight = fullscreenDialRadiusHeight;
const _fullscreenDialCenterY = fullscreenDialCenterY;
const _compactRangeInset = compactRangeInset;
const _compactRangeBottom = compactRangeBottom;
const _fullscreenRangeInset = fullscreenRangeInset;
const _compactDialValueSize = compactDialValueSize;
const _compactDialUnitSize = compactDialUnitSize;
const _compactDigitalValueSize = compactDigitalValueSize;
const _compactDigitalUnitSize = compactDigitalUnitSize;
const _fullscreenValueSize = fullscreenValueSize;
const _fullscreenUnitSize = fullscreenUnitSize;
const _gaugeControlInset = gaugeControlInset;
const _gaugeControlIconSize = gaugeControlIconSize;

class GaugeCard extends StatelessWidget {
  const GaugeCard({
    super.key,
    required this.sensor,
    required this.value,
    required this.isLive,
    required this.isDark,
    this.isEditing = false,
    this.isDial = false,
    this.isFullscreen = false,
    this.valueColorBackground = false,
    this.useMetric = true,
    this.onResize,
    this.onToggleStyle,
    this.onRemove,
    this.onTapDown,
    this.onTap,
  });

  final SensorDefinition sensor;
  final double? value;
  final bool isLive;
  final bool isDark;
  final bool isEditing;
  final bool isDial;
  final bool isFullscreen;
  final bool valueColorBackground;
  final bool useMetric;
  final VoidCallback? onResize;
  final VoidCallback? onToggleStyle;
  final VoidCallback? onRemove;
  final GestureTapDownCallback? onTapDown;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final current = _displayValue ?? _minimum;
    final fraction =
        ((current - _minimum) / math.max(0.0001, _maximum - _minimum)).clamp(
          0.0,
          1.0,
        );
    final accent = _valueColor(current);

    if (isFullscreen) {
      return isDial
          ? _fullscreenDial(
              context: context,
              animatedTarget: fraction,
              accent: accent,
            )
          : _fullscreenDigital(
              context: context,
              animatedTarget: fraction,
              accent: accent,
            );
    }

    return GestureDetector(
      onTapDown: onTapDown,
      onTap: onTap,
      child: Semantics(
        label: '${sensor.label}: ${_formattedValue()} $_unit',
        child: TweenAnimationBuilder<double>(
          tween: Tween(end: fraction),
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          builder: (context, animatedFraction, _) => Container(
            decoration: BoxDecoration(
              color: valueColorBackground
                  ? Color.alphaBlend(
                      accent.withValues(alpha: .18),
                      AppPalette.surface(isDark),
                    )
                  : AppPalette.surface(isDark),
              borderRadius: BorderRadius.circular(appCardRadius),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                Positioned(
                  right: -32,
                  top: -46,
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accent.withValues(alpha: .12),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                if (isDial)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _DialPainter(
                          fraction: animatedFraction,
                          accent: accent,
                          track: isDark
                              ? const Color(0xFF34383F)
                              : const Color(0xFFDDE4ED),
                        ),
                      ),
                    ),
                  ),
                if (isDial)
                  Positioned(
                    left: _compactRangeInset,
                    right: _compactRangeInset,
                    bottom: _compactRangeBottom,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_compact(_minimum), style: _rangeStyle),
                        Text(_compact(_maximum), style: _rangeStyle),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _gaugeCardHorizontal,
                    _gaugeCardTop,
                    _gaugeCardHorizontal,
                    _gaugeCardBottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: accent.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                _sensorIcon(),
                                size: 16,
                                color: accent,
                              ),
                            ),
                            const SizedBox(width: _gaugeSectionGap + 1),
                            Expanded(
                              child: Text(
                                sensor.label,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isDark
                                      ? const Color(0xFFD0D8E4)
                                      : const Color(0xFF26374E),
                                  fontSize: 12,
                                  height: 1.05,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Align(
                        alignment: isDial
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: Transform.translate(
                          offset: isDial ? const Offset(0, 10) : Offset.zero,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: isDial ? 18 : 0,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isDial ? 7 : 0,
                                vertical: isDial ? 3 : 0,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: null,
                                boxShadow: null,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: isDial
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _formattedValue(),
                                            softWrap: false,
                                            style: TextStyle(
                                              fontFamily: 'Geist Mono',
                                              color: value == null
                                                  ? const Color(0xFF566171)
                                                  : isDark
                                                  ? const Color(0xFFF5F7FA)
                                                  : const Color(0xFF172033),
                                              fontSize: _compactDialValueSize,
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                              letterSpacing: -1,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            _unit,
                                            style: TextStyle(
                                              fontFamily: 'Geist Mono',
                                              color: isDark
                                                  ? const Color(0xFF738094)
                                                  : const Color(0xFF68778D),
                                              fontSize: _compactDialUnitSize,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            _formattedValue(),
                                            softWrap: false,
                                            style: TextStyle(
                                              fontFamily: 'Geist Mono',
                                              color: value == null
                                                  ? const Color(0xFF566171)
                                                  : isDark
                                                  ? const Color(0xFFF5F7FA)
                                                  : const Color(0xFF172033),
                                              fontSize:
                                                  _compactDigitalValueSize,
                                              fontWeight: FontWeight.w700,
                                              height: 1,
                                              letterSpacing: -1.2,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 6,
                                              bottom: 2,
                                            ),
                                            child: Text(
                                              _unit,
                                              style: TextStyle(
                                                fontFamily: 'Geist Mono',
                                                color: isDark
                                                    ? const Color(0xFF738094)
                                                    : const Color(0xFF68778D),
                                                fontSize:
                                                    _compactDigitalUnitSize,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isDial ? 25 : 13),
                      if (!isDial)
                        LayoutBuilder(
                          builder: (context, constraints) => Stack(
                            children: [
                              Container(
                                height: 5,
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF30343A)
                                      : const Color(0xFFE3E9F1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              AnimatedContainer(
                                duration: MediaQuery.disableAnimationsOf(context)
                                    ? Duration.zero
                                    : const Duration(milliseconds: 220),
                                height: 5,
                                width: constraints.maxWidth * animatedFraction,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      accent.withValues(alpha: .65),
                                      accent,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: accent.withValues(alpha: .35),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (!isDial) const SizedBox(height: _gaugeSectionGap - 2),
                      if (!isDial)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_compact(_minimum), style: _rangeStyle),
                            Row(
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isLive
                                        ? const Color(0xFF26D995)
                                        : const Color(0xFF536071),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isLive ? 'LIVE' : 'IDLE',
                                  style: _rangeStyle,
                                ),
                              ],
                            ),
                            Text(_compact(_maximum), style: _rangeStyle),
                          ],
                        ),
                    ],
                  ),
                ),
                if (isEditing)
                  Positioned(
                    right: _gaugeControlInset,
                    top: _gaugeControlInset,
                    child: PopupMenuButton<_GaugeAction>(
                      tooltip: 'Gauge layout options',
                      icon: const Icon(
                        Icons.more_horiz_rounded,
                        size: _gaugeControlIconSize,
                      ),
                      onSelected: (action) => switch (action) {
                        _GaugeAction.resize => onResize?.call(),
                        _GaugeAction.style => onToggleStyle?.call(),
                        _GaugeAction.hide => onRemove?.call(),
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: _GaugeAction.resize,
                          child: Text('Resize'),
                        ),
                        PopupMenuItem(
                          value: _GaugeAction.style,
                          child: Text(
                            isDial ? 'Digital display' : 'Dial display',
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem(
                          value: _GaugeAction.hide,
                          child: Text('Hide gauge'),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _fullscreenDigital({
    required BuildContext context,
    required double animatedTarget,
    required Color accent,
  }) => TweenAnimationBuilder<double>(
    tween: Tween(end: animatedTarget),
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
    builder: (context, animatedFraction, _) => Semantics(
      label: '${sensor.label}: ${_formattedValue()} $_unit',
      child: ColoredBox(
        color: const Color(0xFF07090D),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      sensor.label.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF8B949F),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isLive
                          ? const Color(0xFF26D995)
                          : const Color(0xFF4E5763),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _formattedValue(),
                          softWrap: false,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: _fullscreenValueSize,
                            height: .9,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, bottom: 8),
                          child: Text(
                            _unit,
                            style: const TextStyle(
                              color: Color(0xFF8B949F),
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: animatedFraction,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF20242A),
                  valueColor: AlwaysStoppedAnimation(accent),
                ),
              ),
              const SizedBox(height: 7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_compact(_minimum), style: _fullscreenRangeStyle),
                  Text(_compact(_maximum), style: _fullscreenRangeStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _fullscreenDial({
    required BuildContext context,
    required double animatedTarget,
    required Color accent,
  }) => TweenAnimationBuilder<double>(
    tween: Tween(end: animatedTarget),
    duration: MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
    builder: (context, animatedFraction, _) => Semantics(
      label: '${sensor.label}: ${_formattedValue()} $_unit',
      child: ColoredBox(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DialPainter(
                  fraction: animatedFraction,
                  accent: accent,
                  track: const Color(0xFF20242A),
                  fullscreen: true,
                ),
              ),
            ),
            Positioned(
              top: 24,
              left: 24,
              right:
                  MediaQuery.sizeOf(context).width >
                      MediaQuery.sizeOf(context).height
                  ? null
                  : 24,
              child: Column(
                crossAxisAlignment:
                    MediaQuery.sizeOf(context).width >
                        MediaQuery.sizeOf(context).height
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Text(
                    sensor.label.toUpperCase(),
                    textAlign:
                        MediaQuery.sizeOf(context).width >
                            MediaQuery.sizeOf(context).height
                        ? TextAlign.left
                        : TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF8B949F),
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isLive ? 'LIVE' : 'IDLE',
                    style: TextStyle(
                      color: isLive
                          ? const Color(0xFF26D995)
                          : const Color(0xFF566171),
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.8,
                    ),
                  ),
                ],
              ),
            ),
            // Keep the primary reading closer to its label on tall portrait
            // screens instead of leaving an oversized gap in the middle.
            Positioned.fill(
              child: Align(
                // Digital readings benefit from moving up on tall screens;
                // dial readings must stay centered inside the instrument.
                alignment: Alignment(0, isDial ? 0 : -0.18),
                child: FractionallySizedBox(
                  widthFactor: isDial ? .9 : .58,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Flex(
                      direction: isDial ? Axis.vertical : Axis.horizontal,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _formattedValue(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: _fullscreenValueSize,
                            height: .9,
                            fontWeight: FontWeight.w300,
                            letterSpacing: -4,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.visible,
                        ),
                        Padding(
                          padding: isDial
                              ? const EdgeInsets.only(top: 2)
                              : const EdgeInsets.only(left: 10, bottom: 7),
                          child: Text(
                            _unit,
                            style: const TextStyle(
                              color: Color(0xFF8B949F),
                              fontSize: _fullscreenUnitSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: _fullscreenRangeInset,
              right: _fullscreenRangeInset,
              // Keep dial endpoints visually attached to the arc instead of
              // leaving them at the extreme bottom of a tall display.
              bottom: isDial ? 202 : 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_compact(_minimum), style: _fullscreenRangeStyle),
                  Text(_compact(_maximum), style: _fullscreenRangeStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  static const _fullscreenRangeStyle = TextStyle(
    fontFamily: 'Geist Mono',
    color: Color(0xFF5E6670),
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const _rangeStyle = TextStyle(
    fontFamily: 'Geist Mono',
    color: Color(0xFF7D899A),
    fontSize: 9,
    fontWeight: FontWeight.w700,
  );

  double? get _displayValue => value == null ? null : _convert(value!);

  double _convert(double input) {
    if (useMetric) {
      if (sensor.unit == 'PSI') return input / 14.5038;
      return input;
    }
    if (sensor.unit == '°C') return input * 9 / 5 + 32;
    if (sensor.unit == 'km/h') return input / 1.609344;
    return input;
  }

  String get _unit {
    if (useMetric) {
      if (sensor.unit == 'PSI') return 'bar';
      return sensor.unit;
    }
    if (sensor.unit == '°C') return '°F';
    if (sensor.unit == 'km/h') return 'mph';
    return sensor.unit;
  }

  double get _minimum => _convert(sensor.minimum);
  double get _maximum => _convert(sensor.maximum);

  String _formattedValue() => _displayValue == null
      ? '—'
      : _displayValue!.toStringAsFixed(sensor.decimals);

  String _compact(double input) => input == input.roundToDouble()
      ? input.toInt().toString()
      : input.toStringAsFixed(1);

  IconData _sensorIcon() => switch (sensor.id) {
    'engine_rpm' => Icons.speed_rounded,
    'battery_voltage' => Icons.battery_charging_full_rounded,
    'coolant_temp' || 'engine_oil_temp' => Icons.device_thermostat_rounded,
    'lp_fuel_pressure' || 'hp_rail_pressure' => Icons.local_gas_station_rounded,
    'oil_pressure' => Icons.oil_barrel_rounded,
    'boost_pressure' || 'intake_pressure' => Icons.air_rounded,
    'throttle_angle' => Icons.tune_rounded,
    'valvetronic_angle' => Icons.rotate_right_rounded,
    _ => Icons.monitor_heart_outlined,
  };

  Color _valueColor(double input) {
    if (value == null) return const Color(0xFF596575);
    final danger = _convert(sensor.danger);
    final warning = _convert(sensor.warning);
    final dangerLow = danger < warning;
    if ((dangerLow && input <= danger) || (!dangerLow && input >= danger)) {
      return const Color(0xFFFF5064);
    }
    if ((dangerLow && input <= warning) || (!dangerLow && input >= warning)) {
      return const Color(0xFFFFB547);
    }
    if (sensor.id == 'battery_voltage') return AppPalette.orange;
    return AppPalette.blue;
  }
}

enum _GaugeAction { resize, style, hide }

class _DialPainter extends CustomPainter {
  const _DialPainter({
    required this.fraction,
    required this.accent,
    required this.track,
    this.fullscreen = false,
  });
  final double fraction;
  final Color accent;
  final Color track;
  final bool fullscreen;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = fullscreen
        ? math.min(
            size.width * _fullscreenDialRadiusWidth,
            size.height * _fullscreenDialRadiusHeight,
          )
        // Compact cards have a short vertical budget. Keep the instrument
        // below the header and inside the card instead of letting its arc
        // compete with the title and value capsule.
        : math.min(
            size.width * _compactDialRadiusWidth,
            size.height * _compactDialRadiusHeight,
          );
    final center = Offset(
      size.width / 2,
      fullscreen
          ? size.height * _fullscreenDialCenterY
          : size.height * _compactDialCenterY,
    );
    final rect = Rect.fromCircle(center: center, radius: radius);
    const start = math.pi * .75;
    const sweep = math.pi * 1.5;
    final base = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = fullscreen ? 12 : 9
      ..strokeCap = StrokeCap.round;
    final active = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = fullscreen ? 12 : 9
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, start, sweep, false, base);
    canvas.drawArc(rect, start, sweep * fraction, false, active);

    // Instrument-style tick marks make the dial readable at a glance without
    // adding another data source or changing the sensor scale.
    final ticks = Paint()
      ..color = const Color(0xFF8491A2)
      ..strokeWidth = fullscreen ? 2 : 1.25
      ..strokeCap = StrokeCap.round;
    final activeTicks = Paint()
      ..color = accent.withValues(alpha: .9)
      ..strokeWidth = fullscreen ? 2.5 : 1.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i <= 10; i++) {
      final angle = start + sweep * i / 10;
      final outer = Offset(
        center.dx + math.cos(angle) * (radius + (fullscreen ? 10 : 7)),
        center.dy + math.sin(angle) * (radius + (fullscreen ? 10 : 7)),
      );
      final inner = Offset(
        center.dx + math.cos(angle) * (radius - (fullscreen ? 4 : 3)),
        center.dy + math.sin(angle) * (radius - (fullscreen ? 4 : 3)),
      );
      canvas.drawLine(inner, outer, i / 10 <= fraction ? activeTicks : ticks);
    }
    canvas.drawCircle(
      center,
      radius - (fullscreen ? 22 : 17),
      Paint()
        ..color = accent.withValues(alpha: .06)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _DialPainter oldDelegate) =>
      oldDelegate.fraction != fraction ||
      oldDelegate.accent != accent ||
      oldDelegate.track != track ||
      oldDelegate.fullscreen != fullscreen;
}
