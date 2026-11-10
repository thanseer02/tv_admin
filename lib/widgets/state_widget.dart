import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/styles.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.spMin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20.spMin),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.link_off_rounded,
                size: 48.spMin,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(height: 18.spMin),
            Text(title, style: tsS18W600),
            SizedBox(height: 8.spMin),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 380.spMin),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: tsS14W400.copyWith(color: Colors.grey),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 20.spMin),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: Icon(Icons.add, size: 18.spMin),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(40.spMin),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, size: 48.spMin, color: Colors.redAccent),
            SizedBox(height: 16.spMin),
            Text('Unable to load resources', style: tsS18W600),
            SizedBox(height: 6.spMin),
            Text(
              message,
              textAlign: TextAlign.center,
              style: tsS14W400.copyWith(color: Colors.grey),
            ),
            SizedBox(height: 18.spMin),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, size: 16.spMin),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}
