import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/url_item.dart';
import 'url_badge.dart';

/// Card list view for mobile and narrow browser viewports
class UrlMobileList extends StatelessWidget {
  final List<UrlItem> items;
  final Function(UrlItem) onDetails;
  final Function(UrlItem) onEdit;
  final Function(UrlItem) onDelete;
  final Function(UrlItem) onToggleStatus;

  const UrlMobileList({
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
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onToggleStatus(item),
                      child: StatusBadge(status: item.status),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                EnvironmentBadge(environment: item.environment),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black26
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.address,
                          style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF60A5FA)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 16),
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () => onDetails(item),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('View'),
                    ),
                    TextButton.icon(
                      onPressed: () => onEdit(item),
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Edit'),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
                      onPressed: () => onDelete(item),
                      icon: const Icon(Icons.delete_outline, size: 16),
                      label: const Text('Delete'),
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

