import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/styles.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final String? subtitle;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.spMin, vertical: 18.spMin),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title.toUpperCase(),
                    style: tsS11W600.copyWith(
                      letterSpacing: 0.8,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 6.spMin),
                  Text(
                    value,
                    style: tsS26W700.copyWith(letterSpacing: -0.5),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 2.spMin),
                    Text(
                      subtitle!,
                      style: tsS11W600.copyWith(
                        color: isDark ? Colors.white38 : Colors.black45,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              width: 48.spMin,
              height: 48.spMin,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12.spMin),
              ),
              child: Icon(icon, color: iconColor, size: 24.spMin),
            ),
          ],
        ),
      ),
    );
  }
}
