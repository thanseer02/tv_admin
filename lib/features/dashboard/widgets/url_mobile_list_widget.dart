import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/url_item_model.dart';
import '../../../utils/styles.dart';
import '../../../widgets/url_badge_widget.dart';

class UrlMobileListWidget extends StatelessWidget {
  final List<UrlItemModel> items;
  final Function(UrlItemModel) onDetails;
  final Function(UrlItemModel) onEdit;
  final Function(UrlItemModel) onDelete;
  final Function(UrlItemModel) onToggleStatus;

  const UrlMobileListWidget({
    super.key,
    required this.items,
    required this.onDetails,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.spMin),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.spMin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.name, style: tsS14W600),
                    ),
                    GestureDetector(
                      onTap: () => onToggleStatus(item),
                      child: StatusBadgeWidget(status: item.status),
                    ),
                  ],
                ),
                SizedBox(height: 12.spMin),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.spMin, vertical: 8.spMin),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black26
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6.spMin),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.address,
                          style: tsS12W400.copyWith(
                            fontFamily: 'monospace',
                            color: const Color(0xFF60A5FA),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy_rounded, size: 16.spMin),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: 'Copy URL',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.address));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Copied URL'), duration: Duration(seconds: 1)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.spMin),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => onDetails(item),
                      icon: Icon(Icons.visibility_outlined, size: 16.spMin),
                      label: Text('View', style: tsS13W600),
                    ),
                    TextButton.icon(
                      onPressed: () => onEdit(item),
                      icon: Icon(Icons.edit_outlined, size: 16.spMin),
                      label: Text('Edit', style: tsS13W600),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                      onPressed: () => onDelete(item),
                      icon: Icon(Icons.delete_outline, size: 16.spMin),
                      label: Text('Delete', style: tsS13W600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
