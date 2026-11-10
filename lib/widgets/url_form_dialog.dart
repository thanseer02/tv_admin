import 'package:flutter/material.dart';
import '../models/url_item.dart';

/// Modal dialog for Adding or Editing a URL Item
class UrlFormDialog extends StatefulWidget {
  final UrlItem? initialItem;
  final Future<void> Function({
    required String name,
    required String address,
    required String description,
    required UrlEnvironment environment,
    required UrlStatus status,
  }) onSave;

  const UrlFormDialog({
    super.key,
    this.initialItem,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    UrlItem? item,
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
      builder: (context) => UrlFormDialog(
        initialItem: item,
        onSave: onSave,
      ),
    );
  }

  @override
  State<UrlFormDialog> createState() => _UrlFormDialogState();
}

class _UrlFormDialogState extends State<UrlFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _descController;
  late UrlEnvironment _selectedEnv;
  late UrlStatus _selectedStatus;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _addressController = TextEditingController(text: item?.address ?? '');
    _descController = TextEditingController(text: item?.description ?? '');
    _selectedEnv = item?.environment ?? UrlEnvironment.production;
    _selectedStatus = item?.status ?? UrlStatus.active;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      await widget.onSave(
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        description: _descController.text.trim(),
        environment: _selectedEnv,
        status: _selectedStatus,
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
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.initialItem != null;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isEdit ? 'Update Stream URL' : 'Add New Stream URL',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'URL Name *',
                    hintText: 'e.g. Main Lobby Live Stream',
                  ),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
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
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<UrlEnvironment>(
                        value: _selectedEnv,
                        decoration: const InputDecoration(labelText: 'Environment'),
                        items: UrlEnvironment.values.map((env) {
                          return DropdownMenuItem(value: env, child: Text(env.label));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedEnv = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: DropdownButtonFormField<UrlStatus>(
                        value: _selectedStatus,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: UrlStatus.values.map((status) {
                          return DropdownMenuItem(value: status, child: Text(status.label));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedStatus = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
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
        TextButton(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _handleSubmit,
          child: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text(isEdit ? 'Save Changes' : 'Create URL'),
        ),
      ],
    );
  }
}

