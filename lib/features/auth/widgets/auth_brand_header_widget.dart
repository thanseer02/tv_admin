import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../utils/styles.dart';

class AuthBrandHeaderWidget extends StatelessWidget {
  const AuthBrandHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 58.spMin,
          height: 58.spMin,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.spMin),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                blurRadius: 16.spMin,
                offset: Offset(0, 8.spMin),
              ),
            ],
          ),
          child: Icon(Icons.link_rounded, color: Colors.white, size: 30.spMin),
        ),
        SizedBox(height: 20.spMin),
        Text(
          'LinkDesk',
          textAlign: TextAlign.center,
          style: tsS26W700.copyWith(letterSpacing: -0.5),
        ),
        SizedBox(height: 4.spMin),
        Text(
          'URL Management & Streaming Admin Portal',
          textAlign: TextAlign.center,
          style: tsS13W600.copyWith(
            fontWeight: FontWeight.normal,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ),
      ],
    );
  }
}

