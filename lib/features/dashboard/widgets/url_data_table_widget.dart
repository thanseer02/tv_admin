import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/url_item_model.dart';
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
        constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 96),
        child: DataTable(
          headingRowHeight: 48,
          dataRowMinHeight: 64,
          dataRowMaxHeight: 72,
          horizontalMargin: 20,
          columnSpacing: 24,
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
                        const SizedBox(height: 4),
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
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: Text(
                          item.address,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: Color(0xFF60A5FA),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 15),
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
                    borderRadius: BorderRadius.circular(20),
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
                        icon: const Icon(Icons.visibility_outlined, size: 18),
                        tooltip: 'View Details',
                        onPressed: () => onDetails(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF60A5FA)),
                        tooltip: 'Edit URL',
                        onPressed: () => onEdit(item),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
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

