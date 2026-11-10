import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../widgets/stat_card_widget.dart';

class DashboardStatsHeaderWidget extends StatelessWidget {
  final int total;
  final int active;
  final int inactive;

  const DashboardStatsHeaderWidget({
    super.key,
    required this.total,
    required this.active,
    required this.inactive,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 768;
        final stats = [
          StatCardWidget(
            title: 'Total URLs',
            value: total.toString(),
            icon: Icons.language_rounded,
            iconColor: const Color(0xFF6366F1),
            subtitle: 'All configured stream endpoints',
          ),
          StatCardWidget(
            title: 'Active Streams',
            value: active.toString(),
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF10B981),
            subtitle: 'Currently routing live traffic',
          ),
          StatCardWidget(
            title: 'Inactive / Paused',
            value: inactive.toString(),
            icon: Icons.pause_circle_outline_rounded,
            iconColor: const Color(0xFF94A3B8),
            subtitle: 'Disabled or standby streams',
          ),
        ];

        if (isWide) {
          return Row(
            children: stats
                .map((card) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.spMin),
                        child: card,
                      ),
                    ))
                .toList(),
          );
        } else {
          return Column(
            children: stats
                .map((card) => Padding(
                      padding: EdgeInsets.only(bottom: 12.spMin),
                      child: card,
                    ))
                .toList(),
          );
        }
      },
    );
  }
}

