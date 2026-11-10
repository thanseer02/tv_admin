import 'package:flutter/material.dart';
import '../model/url_item_model.dart';
import '../widgets/delete_confirmation_dialog_widget.dart';
import '../widgets/url_data_table_widget.dart';
import '../widgets/url_details_dialog_widget.dart';
import '../widgets/url_form_dialog_widget.dart';
import '../widgets/url_mobile_list_widget.dart';

class DashboardTableSectionWidget extends StatelessWidget {
  final List<UrlItemModel> items;
  final bool isDesktop;
  final Function(UrlItemModel) onUpdate;
  final Function(String) onDelete;
  final Function(UrlItemModel) onToggleStatus;

  const DashboardTableSectionWidget({
    super.key,
    required this.items,
    required this.isDesktop,
    required this.onUpdate,
    required this.onDelete,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return UrlDataTableWidget(
        items: items,
        onDetails: (item) => UrlDetailsDialogWidget.show(
          context,
          item,
          onDelete: () {
            DeleteConfirmationDialogWidget.show(
              context: context,
              title: item.name,
              onConfirm: () async => onDelete(item.id),
            );
          },
        ),
        onEdit: (item) {
          UrlFormDialogWidget.show(
            context: context,
            item: item,
            onSave: ({required name, required address, required description, required environment, required status}) async {
              await onUpdate(
                item.copyWith(
                  name: name,
                  address: address,
                  description: description,
                  environment: environment,
                  status: status,
                ),
              );
            },
          );
        },
        onDelete: (item) {
          DeleteConfirmationDialogWidget.show(
            context: context,
            title: item.name,
            onConfirm: () async => onDelete(item.id),
          );
        },
        onToggleStatus: onToggleStatus,
      );
    } else {
      return UrlMobileListWidget(
        items: items,
        onDetails: (item) => UrlDetailsDialogWidget.show(
          context,
          item,
          onDelete: () {
            DeleteConfirmationDialogWidget.show(
              context: context,
              title: item.name,
              onConfirm: () async => onDelete(item.id),
            );
          },
        ),
        onEdit: (item) {
          UrlFormDialogWidget.show(
            context: context,
            item: item,
            onSave: ({required name, required address, required description, required environment, required status}) async {
              await onUpdate(
                item.copyWith(
                  name: name,
                  address: address,
                  description: description,
                  environment: environment,
                  status: status,
                ),
              );
            },
          );
        },
        onDelete: (item) {
          DeleteConfirmationDialogWidget.show(
            context: context,
            title: item.name,
            onConfirm: () async => onDelete(item.id),
          );
        },
        onToggleStatus: onToggleStatus,
      );
    }
  }
}

