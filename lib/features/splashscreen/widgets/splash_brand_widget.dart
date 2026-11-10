import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/styles.dart';

class SplashBrandWidget extends StatelessWidget {
  const SplashBrandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72.spMin,
          height: 72.spMin,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(18.spMin),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Icon(Icons.link_rounded, color: Colors.white, size: 36.spMin),
        ),
        SizedBox(height: 20.spMin),
        Text(
          'LinkDesk',
          style: tsS26W700.copyWith(letterSpacing: -0.5),
        ),
        SizedBox(height: 8.spMin),
        Text(
          'Stream & Display Management Portal',
          style: tsS14W400.copyWith(color: Colors.grey),
        ),
        SizedBox(height: 36.spMin),
        SizedBox(
          width: 28.spMin,
          height: 28.spMin,
          child: const CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F46E5)),
          ),
        ),
      ],
    );
  }
}

