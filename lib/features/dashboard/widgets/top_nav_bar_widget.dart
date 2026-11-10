import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../utils/styles.dart';

class TopNavBarWidget extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;

  const TopNavBarWidget({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.link_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'LinkDesk',
            style: tsS18W600.copyWith(letterSpacing: -0.5),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'PORTAL',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF6366F1)),
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined, size: 20),
            onPressed: onToggleTheme,
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF6366F1),
            child: Text(
              (user?.name.isNotEmpty == true ? user!.name[0] : 'A').toUpperCase(),
              style: tsS13W600.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          if (MediaQuery.of(context).size.width >= 600) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  user?.name ?? 'Admin',
                  style: tsS13W600,
                ),
                Text(
                  user?.role ?? 'Administrator',
                  style: tsS11W600.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            const SizedBox(width: 12),
          ],
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout_rounded, size: 20, color: Colors.grey),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}
