import 'package:flutter/material.dart';
import '../../../utils/styles.dart';

class ForgotPasswordDialogWidget extends StatefulWidget {
  final Future<void> Function(String email) onSubmit;

  const ForgotPasswordDialogWidget({super.key, required this.onSubmit});

  static Future<void> show(BuildContext context, Future<void> Function(String email) onSubmit) {
    return showDialog(
      context: context,
      builder: (context) => ForgotPasswordDialogWidget(onSubmit: onSubmit),
    );
  }

  @override
  State<ForgotPasswordDialogWidget> createState() => _ForgotPasswordDialogWidgetState();
}

class _ForgotPasswordDialogWidgetState extends State<ForgotPasswordDialogWidget> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSend() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await widget.onSubmit(_emailController.text.trim());
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset instructions have been sent to your email.'),
            backgroundColor: Color(0xFF10B981),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Reset Your Password', style: tsS18W600),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter the email address associated with your LinkDesk admin account and we will send you a reset link.',
                style: tsS13W600.copyWith(fontWeight: FontWeight.normal, color: Colors.grey, height: 1.4),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: tsS14W400,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Please enter your email';
                  if (!val.contains('@') || !val.contains('.')) return 'Please enter a valid email';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel', style: tsS14W600),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSend,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : Text('Send Reset Link', style: tsS14W600.copyWith(color: Colors.white)),
        ),
      ],
    );
  }
}

