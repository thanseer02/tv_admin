import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/url_item_model.dart';
import '../../../utils/styles.dart';
import '../../../widgets/url_badge_widget.dart';

class UrlDataTableWidget extends StatelessWidget {
  final List<UrlItemModel> items;
  final Function(UrlItemModel) onDetails;
  final Function(UrlItemModel) onEdit;
  final Function(UrlItemModel) onDelete;
  final Function(UrlItemModel) onToggleStatus;

  const UrlDataTableWidget({
    super.key,
    required this.items,
    required this.onDetails,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 96.spMin),
        child: DataTable(
          headingRowHeight: 48.spMin,
          dataRowMinHeight: 64.spMin,
          dataRowMaxHeight: 72.spMin,
          horizontalMargin: 20.spMin,
          columnSpacing: 24.spMin,
          columns: [
            DataColumn(label: Text('NAME & ENVIRONMENT', style: tsS11W600)),
            DataColumn(label: Text('URL ADDRESS', style: tsS11W600)),
            DataColumn(label: Text('STATUS', style: tsS11W600)),
            DataColumn(label: Text('LAST UPDATED', style: tsS11W600)),
            DataColumn(label: Text('ACTIONS', style: tsS11W600)),
          ],
          rows: items.map((item) {
            return DataRow(
              cells: [
                DataCell(
                  InkWell(
                    onTap: () => onDetails(item),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(item.name, style: tsS13W600),
                        SizedBox(height: 4.spMin),
                        EnvironmentBadgeWidget(environment: item.environment),
                      ],
                    ),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 280.spMin),
                        child: Text(
                          item.address,
                          overflow: TextOverflow.ellipsis,
                          style: tsS12W400.copyWith(
                            fontFamily: 'monospace',
                            color: const Color(0xFF60A5FA),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.copy_rounded, size: 15.spMin),
                        tooltip: 'Copy URL',
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: item.address));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Copied URL to clipboard'),
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                DataCell(
                  InkWell(
                    onTap: () => onToggleStatus(item),
                    borderRadius: BorderRadius.circular(20.spMin),
                    child: Tooltip(
                      message: 'Click to toggle Active/Inactive',
                      child: StatusBadgeWidget(status: item.status),
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '${item.updatedAt.year}-${item.updatedAt.month.toString().padLeft(2, '0')}-${item.updatedAt.day.toString().padLeft(2, '0')}',
                    style: tsS12W400.copyWith(color: Colors.grey),
                  ),
                ),
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility_outlined, size: 18.spMin),
                        tooltip: 'View Details',
                        onPressed: () => onDetails(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_outlined, size: 18.spMin, color: const Color(0xFF60A5FA)),
                        tooltip: 'Edit URL',
                        onPressed: () => onEdit(item),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline_rounded, size: 18.spMin, color: Colors.redAccent),
                        tooltip: 'Delete URL',
                        onPressed: () => onDelete(item),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
