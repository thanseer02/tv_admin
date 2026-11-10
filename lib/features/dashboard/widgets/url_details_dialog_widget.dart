import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/url_item_model.dart';
import '../../../utils/styles.dart';
import '../../../widgets/url_badge_widget.dart';

class UrlDetailsDialogWidget extends StatelessWidget {
  final UrlItemModel item;

  const UrlDetailsDialogWidget({super.key, required this.item});

  static Future<void> show(BuildContext context, UrlItemModel item) {
    return showDialog(
      context: context,
      builder: (context) => UrlDetailsDialogWidget(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 16, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      actionsPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(item.name, style: tsS18W600)),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  EnvironmentBadgeWidget(environment: item.environment),
                  const SizedBox(width: 8),
                  StatusBadgeWidget(status: item.status),
                ],
              ),
              const SizedBox(height: 20),
              _buildField(
                title: 'URL Address',
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SelectableText(
                          item.address,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 13,
                            color: Color(0xFF60A5FA),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 18),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
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
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
