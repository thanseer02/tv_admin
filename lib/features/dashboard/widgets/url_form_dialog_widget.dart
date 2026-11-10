import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/url_item_model.dart';
import '../../../utils/styles.dart';

class UrlFormDialogWidget extends StatefulWidget {
  final UrlItemModel? initialItem;
  final Future<void> Function({
    required String name,
    required String address,
    required String description,
    required UrlEnvironment environment,
    required UrlStatus status,
  }) onSave;

  const UrlFormDialogWidget({
    super.key,
    this.initialItem,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    UrlItemModel? item,
    required Future<void> Function({
      required String name,
      required String address,
      required String description,
      required UrlEnvironment environment,
      required UrlStatus status,
    }) onSave,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => UrlFormDialogWidget(
        initialItem: item,
        onSave: onSave,
      ),
    );
  }

  @override
  State<UrlFormDialogWidget> createState() => _UrlFormDialogWidgetState();
}

class _UrlFormDialogWidgetState extends State<UrlFormDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _descController;
  late ValueNotifier<UrlStatus> _selectedStatusNotifier;
  final ValueNotifier<bool> _isSubmittingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _addressController = TextEditingController(text: item?.address ?? '');
    _descController = TextEditingController(text: item?.description ?? '');
    _selectedStatusNotifier = ValueNotifier<UrlStatus>(item?.status ?? UrlStatus.active);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descController.dispose();
    _selectedStatusNotifier.dispose();
    _isSubmittingNotifier.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    _isSubmittingNotifier.value = true;
    try {
      await widget.onSave(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        description: _descController.text.trim(),
        environment: widget.initialItem?.environment ?? UrlEnvironment.production,
        status: _selectedStatusNotifier.value,
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) _isSubmittingNotifier.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.spMin)),
      title: Text(
        isEdit ? 'Update Stream URL' : 'Add New Stream URL',
        style: tsS18W600,
      ),
      content: SizedBox(
        width: 520.spMin,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  style: tsS14W400,
                  decoration: const InputDecoration(
                    labelText: 'URL Name *',
                    hintText: 'e.g. Main Lobby Live Stream',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
                ),
                SizedBox(height: 16.spMin),
                TextFormField(
                  controller: _addressController,
                  style: tsS14W400,
                  decoration: const InputDecoration(
                    labelText: 'URL Address / Endpoint *',
                    hintText: 'https://stream.domain.com/live.m3u8',
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Please enter a URL';
                    final uri = Uri.tryParse(v.trim());
                    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
                      return 'Enter a valid URL (including http:// or https://)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.spMin),
                ValueListenableBuilder<UrlStatus>(
                  valueListenable: _selectedStatusNotifier,
                  builder: (context, selectedStatus, _) {
                    return DropdownButtonFormField<UrlStatus>(
                      initialValue: selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status'),
                      items: UrlStatus.values.map((status) {
                        return DropdownMenuItem(value: status, child: Text(status.label, style: tsS14W400));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) _selectedStatusNotifier.value = val;
                      },
                    );
                  },
                ),
                SizedBox(height: 16.spMin),
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  style: tsS14W400,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Notes regarding resolution, DRM, screen placement...',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ValueListenableBuilder<bool>(
          valueListenable: _isSubmittingNotifier,
          builder: (context, isSubmitting, _) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
                  child: Text('Cancel', style: tsS14W600),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _handleSubmit,
                  child: isSubmitting
                      ? SizedBox(
                          width: 16.spMin,
                          height: 16.spMin,
                          child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(isEdit ? 'Save Changes' : 'Create URL', style: tsS14W600.copyWith(color: Colors.white)),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
