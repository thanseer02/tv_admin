import 'package:flutter/material.dart';
import '../configs/app_configs.dart';

void showSnackBar(
  String message, {
  BuildContext? context,
  bool isError = false,
  Duration duration = const Duration(seconds: 2),
}) {
  final currentContext = context ?? AppConfig.navKey.currentContext;
  if (currentContext == null) return;

  final messenger = ScaffoldMessenger.maybeOf(currentContext);
  if (messenger == null) return;

  messenger.clearSnackBars();
  messenger.showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.redAccent : const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
      duration: duration,
    ),
  );
}

// Global alias for compatibility
void showToast(
  String msg, {
  BuildContext? context,
  bool isError = false,
}) {
  showSnackBar(msg, context: context, isError: isError);
}

