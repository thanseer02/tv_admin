import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/styles.dart';

class DeleteConfirmationDialogWidget extends StatefulWidget {
  final String title;
  final Future<void> Function() onConfirm;

  const DeleteConfirmationDialogWidget({
    super.key,
    required this.title,
    required this.onConfirm,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required Future<void> Function() onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteConfirmationDialogWidget(
        title: title,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  State<DeleteConfirmationDialogWidget> createState() => _DeleteConfirmationDialogWidgetState();
}

class _DeleteConfirmationDialogWidgetState extends State<DeleteConfirmationDialogWidget> {
  bool _isDeleting = false;

  Future<void> _handleDelete() async {
    setState(() => _isDeleting = true);
    try {
      await widget.onConfirm();
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.spMin)),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 24.spMin),
          SizedBox(width: 8.spMin),
          Text('Delete URL?', style: tsS18W600),
        ],
      ),
      content: SizedBox(
        width: 420.spMin,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to permanently delete this URL? Any connected screens will lose the active feed.',
              style: tsS13W600.copyWith(fontWeight: FontWeight.normal, height: 1.4),
            ),
            SizedBox(height: 12.spMin),
            Container(
              padding: EdgeInsets.all(10.spMin),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8.spMin),
                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
              ),
              child: Text(widget.title, style: tsS13W600),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => Navigator.of(context).pop(false),
          child: Text('Cancel', style: tsS14W600),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          onPressed: _isDeleting ? null : _handleDelete,
          child: _isDeleting
              ? SizedBox(
                  width: 16.spMin,
                  height: 16.spMin,
                  child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text('Delete URL', style: tsS14W600.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}
