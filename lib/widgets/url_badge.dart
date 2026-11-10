import 'package:flutter/material.dart';
import '../models/url_item.dart';

/// Reusable Badge for Environment (Production, Staging, Testing, Other)
class EnvironmentBadge extends StatelessWidget {
  final UrlEnvironment environment;

  const EnvironmentBadge({super.key, required this.environment});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (environment) {
      case UrlEnvironment.production:
        bg = const Color(0xFF6366F1).withOpacity(0.15);
        fg = const Color(0xFF818CF8);
        break;
      case UrlEnvironment.staging:
        bg = const Color(0xFFF59E0B).withOpacity(0.15);
        fg = const Color(0xFFFBBF24);
        break;
      case UrlEnvironment.testing:
        bg = const Color(0xFF3B82F6).withOpacity(0.15);
        fg = const Color(0xFF60A5FA);
        break;
      case UrlEnvironment.other:
        bg = const Color(0xFF64748B).withOpacity(0.15);
        fg = const Color(0xFF94A3B8);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withOpacity(0.3), width: 1),
      ),
      child: Text(
        environment.label,
        style: TextStyle(
          color: fg,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// Reusable Badge for Status (Active / Inactive)
class StatusBadge extends StatelessWidget {
  final UrlStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == UrlStatus.active;
    final Color color = isActive ? const Color(0xFF10B981) : const Color(0xFF94A3B8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

