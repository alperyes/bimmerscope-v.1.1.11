import 'package:bmw_app/design/app_palette.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
    required this.onShowConnectionGuide,
    this.onUnitsChanged,
  });

  final bool isDark;
  final VoidCallback onToggleTheme;
  final VoidCallback onShowConnectionGuide;
  final ValueChanged<bool>? onUnitsChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _reconnectKey = 'bimmerscope.reconnect_policy';
  static const _unitsKey = 'bimmerscope.units';
  static const _retentionKey = 'bimmerscope.log_retention_days';
  String reconnectPolicy = 'automatic';
  String units = 'metric';
  int retentionDays = 30;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      reconnectPolicy = preferences.getString(_reconnectKey) ?? 'automatic';
      units = preferences.getString(_unitsKey) ?? 'metric';
      retentionDays = preferences.getInt(_retentionKey) ?? 30;
    });
  }

  Future<void> _save(String key, Object value) async {
    final preferences = await SharedPreferences.getInstance();
    if (value is String) {
      await preferences.setString(key, value);
    } else if (value is int) {
      await preferences.setInt(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final muted = AppPalette.secondary(isDark);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          Text('Appearance', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          _section(
            context,
            children: [
              ListTile(
                leading: Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppPalette.blue,
                ),
                title: Text(isDark ? 'Dark appearance' : 'Light appearance'),
                subtitle: Text(
                  'Switch to ${isDark ? 'light' : 'dark'} appearance',
                  style: TextStyle(color: muted),
                ),
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => widget.onToggleTheme(),
                ),
                onTap: widget.onToggleTheme,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Session defaults',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          _section(
            context,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.visibility_outlined,
                  color: AppPalette.blue,
                ),
                title: const Text('Live-session guardrails'),
                subtitle: Text(
                  'The screen stays awake during live data and stale telemetry ends a session safely.',
                  style: TextStyle(color: muted),
                ),
                trailing: const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppPalette.green,
                ),
              ),
              Divider(
                height: 1,
                indent: 56,
                color: AppPalette.separator(isDark).withValues(alpha: .45),
              ),
              ListTile(
                leading: const Icon(Icons.sync_rounded, color: AppPalette.blue),
                title: const Text('Reconnect behavior'),
                subtitle: Text(switch (reconnectPolicy) {
                  'prompt' => 'Ask before retrying after a failure',
                  'manual' => 'Wait for you to tap Retry',
                  _ => 'Recover transient ENET gaps automatically',
                }, style: TextStyle(color: muted)),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: reconnectPolicy,
                    items: const [
                      DropdownMenuItem(value: 'automatic', child: Text('Auto')),
                      DropdownMenuItem(value: 'prompt', child: Text('Prompt')),
                      DropdownMenuItem(value: 'manual', child: Text('Manual')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => reconnectPolicy = value);
                      _save(_reconnectKey, value);
                    },
                  ),
                ),
              ),
              Divider(
                height: 1,
                indent: 56,
                color: AppPalette.separator(isDark).withValues(alpha: .45),
              ),
              ListTile(
                leading: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppPalette.orange,
                ),
                title: const Text('Read-only protection'),
                subtitle: Text(
                  'No flashing, unlocking, coding, or calibration writes are available.',
                  style: TextStyle(color: muted),
                ),
                trailing: const Icon(
                  Icons.verified_user_outlined,
                  color: AppPalette.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text('Data and units', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          _section(
            context,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.straighten_rounded,
                  color: AppPalette.blue,
                ),
                title: const Text('Units'),
                subtitle: Text(
                  units == 'imperial' ? '°F, psi, mph' : '°C, bar, km/h',
                  style: TextStyle(color: muted),
                ),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: units,
                    items: const [
                      DropdownMenuItem(value: 'metric', child: Text('Metric')),
                      DropdownMenuItem(
                        value: 'imperial',
                        child: Text('Imperial'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => units = value);
                      widget.onUnitsChanged?.call(value == 'imperial');
                      _save(_unitsKey, value);
                    },
                  ),
                ),
              ),
              Divider(
                height: 1,
                indent: 56,
                color: AppPalette.separator(isDark).withValues(alpha: .45),
              ),
              ListTile(
                leading: const Icon(
                  Icons.auto_delete_outlined,
                  color: AppPalette.blue,
                ),
                title: const Text('Log retention'),
                subtitle: Text(
                  retentionDays == 0
                      ? 'Keep logs indefinitely'
                      : 'Delete logs older than $retentionDays days',
                  style: TextStyle(color: muted),
                ),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: retentionDays,
                    items: const [
                      DropdownMenuItem(value: 7, child: Text('7 days')),
                      DropdownMenuItem(value: 30, child: Text('30 days')),
                      DropdownMenuItem(value: 90, child: Text('90 days')),
                      DropdownMenuItem(value: 0, child: Text('Unlimited')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => retentionDays = value);
                      _save(_retentionKey, value);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text('Connection', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          _section(
            context,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.cable_rounded,
                  color: AppPalette.blue,
                ),
                title: const Text('Connection guide'),
                subtitle: Text(
                  'Four steps for direct ENET setup and vehicle discovery',
                  style: TextStyle(color: muted),
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: widget.onShowConnectionGuide,
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            'Vehicle operations remain read-only in this build.',
            style: TextStyle(color: muted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, {required List<Widget> children}) =>
      Container(
        decoration: BoxDecoration(
          color: AppPalette.surface(widget.isDark),
          borderRadius: BorderRadius.circular(appCardRadius),
          border: Border.all(
            color: AppPalette.separator(widget.isDark).withValues(alpha: .5),
          ),
        ),
        child: Column(children: children),
      );
}
