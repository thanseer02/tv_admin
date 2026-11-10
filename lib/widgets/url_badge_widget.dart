import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../features/dashboard/model/url_item_model.dart';
import '../utils/styles.dart';

class EnvironmentBadgeWidget extends StatelessWidget {
  final UrlEnvironment environment;

  const EnvironmentBadgeWidget({super.key, required this.environment});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (environment) {
      case UrlEnvironment.production:
        bg = const Color(0xFF6366F1).withValues(alpha: 0.15);
        fg = const Color(0xFF818CF8);
        break;
      case UrlEnvironment.staging:
        bg = const Color(0xFFF59E0B).withValues(alpha: 0.15);
        fg = const Color(0xFFFBBF24);
        break;
      case UrlEnvironment.testing:
        bg = const Color(0xFF3B82F6).withValues(alpha: 0.15);
        fg = const Color(0xFF60A5FA);
        break;
      case UrlEnvironment.other:
        bg = const Color(0xFF64748B).withValues(alpha: 0.15);
        fg = const Color(0xFF94A3B8);
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.spMin, vertical: 4.spMin),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6.spMin),
        border: Border.all(color: fg.withValues(alpha: 0.3), width: 1.spMin),
      ),
      child: Text(
        environment.label,
        style: tsS11W600.copyWith(color: fg, letterSpacing: 0.3),
      ),
    );
  }
}

class StatusBadgeWidget extends StatelessWidget {
  final UrlStatus status;

  const StatusBadgeWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == UrlStatus.active;
    final Color color = isActive ? const Color(0xFF10B981) : const Color(0xFF94A3B8);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.spMin, vertical: 4.spMin),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20.spMin),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.spMin,
            height: 6.spMin,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.spMin),
          Text(
            status.label,
            style: tsS12W600.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
