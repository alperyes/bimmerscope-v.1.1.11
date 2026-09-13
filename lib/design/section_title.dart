import 'package:flutter/material.dart';

const sectionTitleTopGap = 12.0;
const sectionTitleBottomGap = 9.0;
const sectionTitleHeight = 48.0;

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
  Widget build(BuildContext context) => Text(
    title,
    style: const TextStyle(
      fontSize: 20,
      height: 1.05,
      fontWeight: FontWeight.w800,
      letterSpacing: -.45,
    ),
  );
}
