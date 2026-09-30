import 'package:flutter/material.dart';
import 'package:bmw_app/design/app_palette.dart';

const sectionTitleTopGap = 12.0;
const sectionTitleBottomGap = 9.0;
const sectionTitleHeight = 48.0;

class AppCountBadge extends StatelessWidget {
  const AppCountBadge({super.key, required this.label, required this.isDark});

  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: AppPalette.secondary(isDark).withValues(alpha: .12),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: AppPalette.secondary(isDark),
        fontSize: 11,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({super.key, required this.title, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: sectionTitleHeight,
    child: Row(
      children: [
        Expanded(child: AppSectionTitle(title)),
        if (trailing != null) trailing!,
      ],
    ),
  );
}

/// Shared section heading treatment used throughout the main app surfaces.
class AppSectionTitle extends StatelessWidget {
  const AppSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    label: title,
    child: Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 20,
        height: 1.05,
        fontWeight: FontWeight.w800,
        letterSpacing: -.45,
      ),
    ),
  );
}
