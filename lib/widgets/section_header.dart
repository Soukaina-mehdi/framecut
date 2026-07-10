import 'package:flutter/material.dart';
import '../app/theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final bool dark;

  const SectionHeader({
    super.key,
    required this.title,
    this.trailing,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: dark ? Colors.white38 : AppTheme.muted,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
