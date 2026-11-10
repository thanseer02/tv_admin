import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/styles.dart';

class LogoutConfirmationDialogWidget extends StatelessWidget {
  const LogoutConfirmationDialogWidget({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const LogoutConfirmationDialogWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.spMin)),
      title: Row(
        children: [
          Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22.spMin),
          SizedBox(width: 8.spMin),
          Text('Log Out', style: tsS18W600),
        ],
      ),
      content: SizedBox(
        width: 380.spMin,
        child: Text(
          'Are you sure you want to log out of your LinkDesk admin session?',
          style: tsS14W400.copyWith(color: Colors.grey, height: 1.4),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel', style: tsS14W600),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Log Out', style: tsS14W600),
        ),
      ],
    );
  }
}

