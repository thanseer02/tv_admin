import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/url_item_model.dart';
import '../../../utils/styles.dart';
import '../../../widgets/url_badge_widget.dart';

class UrlDetailsDialogWidget extends StatelessWidget {
  final UrlItemModel item;
  final VoidCallback? onDelete;

  const UrlDetailsDialogWidget({
    super.key,
    required this.item,
    this.onDelete,
  });

  static Future<void> show(
    BuildContext context,
    UrlItemModel item, {
    VoidCallback? onDelete,
  }) {
    return showDialog(
      context: context,
      builder: (context) => UrlDetailsDialogWidget(
        item: item,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      titlePadding: EdgeInsets.fromLTRB(24.spMin, 20.spMin, 16.spMin, 12.spMin),
      contentPadding: EdgeInsets.symmetric(horizontal: 24.spMin, vertical: 12.spMin),
      actionsPadding: EdgeInsets.all(16.spMin),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.spMin)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item.name, style: tsS18W600)),
          IconButton(
            icon: Icon(Icons.close, size: 20.spMin),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: 520.spMin,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatusBadgeWidget(status: item.status),
              SizedBox(height: 20.spMin),
              _buildField(
                title: 'URL Address',
                child: Container(
                  padding: EdgeInsets.all(12.spMin),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8.spMin),
                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          item.address,
                          style: tsS13W600.copyWith(
                            fontFamily: 'monospace',
                            color: const Color(0xFF60A5FA),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy_rounded, size: 18.spMin),
                        tooltip: 'Copy URL',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.address));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('URL copied to clipboard!'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.spMin),
              _buildField(
                title: 'Description',
                child: Text(
                  item.description.isNotEmpty ? item.description : 'No description provided.',
                  style: tsS13W600.copyWith(
                    fontWeight: FontWeight.normal,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 16.spMin),
              Row(
                children: [
                  Expanded(
                    child: _buildField(
                      title: 'Created At',
                      child: Text(
                        _formatDate(item.createdAt),
                        style: tsS12W400.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                  Expanded(
                    child: _buildField(
                      title: 'Last Updated',
                      child: Text(
                        _formatDate(item.updatedAt),
                        style: tsS12W400.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (onDelete != null)
          TextButton.icon(
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.of(context).pop();
              onDelete!();
            },
            icon: Icon(Icons.delete_outline_rounded, size: 18.spMin),
            label: Text('Delete URL', style: tsS14W600),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Close', style: tsS14W600),
        ),
      ],
    );
  }

  Widget _buildField({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: tsS11W600.copyWith(color: Colors.grey)),
        SizedBox(height: 6.spMin),
        child,
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
