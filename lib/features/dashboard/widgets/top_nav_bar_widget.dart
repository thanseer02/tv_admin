import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.spMin, vertical: 14.spMin),
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
            padding: EdgeInsets.all(8.spMin),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(10.spMin),
            ),
            child: Icon(Icons.link_rounded, color: Colors.white, size: 20.spMin),
          ),
          SizedBox(width: 12.spMin),
          Text(
            'LinkDesk',
            style: tsS18W600.copyWith(letterSpacing: -0.5),
          ),
          SizedBox(width: 8.spMin),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.spMin, vertical: 2.spMin),
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4.spMin),
            ),
            child: Text(
              'PORTAL',
              style: tsS11W600.copyWith(fontSize: 10.spMin, color: const Color(0xFF6366F1)),
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            icon: Icon(
              isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              size: 20.spMin,
            ),
            onPressed: onToggleTheme,
          ),
          SizedBox(width: 12.spMin),
          CircleAvatar(
            radius: 16.spMin,
            backgroundColor: const Color(0xFF6366F1),
            child: Text(
              'A',
              style: tsS13W600.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(width: 10.spMin),
          if (MediaQuery.of(context).size.width >= 600) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Super Admin',
                  style: tsS13W600,
                ),
                Text(
                  'Administrator',
                  style: tsS11W600.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                ),
              ],
            ),
            SizedBox(width: 12.spMin),
          ],
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout_rounded, size: 20.spMin, color: Colors.grey),
            onPressed: onLogout,
          ),
        ],
      ),
    );
  }
}
