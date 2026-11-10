import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../utils/styles.dart';
import '../view_model/login_view_model.dart';
import 'forgot_password_dialog_widget.dart';

class LoginFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final VoidCallback onLoginSubmit;

  const LoginFormWidget({
    super.key,
    required this.formKey,
    required this.onLoginSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Consumer<LoginViewModel>(
            builder: (context, vm, _) {
              if (vm.errorMessage == null) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(bottom: 18.spMin),
                child: Container(
                  padding: EdgeInsets.all(12.spMin),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8.spMin),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.redAccent, size: 18.spMin),
                      SizedBox(width: 8.spMin),
                      Expanded(
                        child: Text(
                          vm.errorMessage!,
                          style: tsS13W600.copyWith(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Consumer<LoginViewModel>(
            builder: (context, vm, _) => TextFormField(
              controller: vm.emailController,
              keyboardType: TextInputType.emailAddress,
              style: tsS14W400,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email_outlined, size: 20.spMin),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) return 'Enter email address';
                if (!val.contains('@')) return 'Enter a valid email';
                return null;
              },
            ),
          ),
          SizedBox(height: 18.spMin),
          Consumer<LoginViewModel>(
            builder: (context, vm, _) => TextFormField(
              controller: vm.passwordController,
              obscureText: vm.obscurePassword,
              style: tsS14W400,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline, size: 20.spMin),
                suffixIcon: IconButton(
                  icon: Icon(
                    vm.obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 20.spMin,
                  ),
                  onPressed: () => context.read<LoginViewModel>().togglePasswordVisibility(),
                ),
              ),
              validator: (val) {
                if (val == null || val.isEmpty) return 'Enter password';
                if (val.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
          ),
          SizedBox(height: 12.spMin),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24.spMin,
                    height: 24.spMin,
                    child: Consumer<LoginViewModel>(
                      builder: (context, vm, _) => Checkbox(
                        value: vm.rememberMe,
                        onChanged: (v) => context.read<LoginViewModel>().setRememberMe(v ?? false),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.spMin),
                  Text(
                    'Remember me',
                    style: tsS13W600.copyWith(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  ForgotPasswordDialogWidget.show(
                    context,
                    (email) => context.read<LoginViewModel>().sendPasswordReset(email),
                  );
                },
                child: Text('Forgot password?', style: tsS13W600),
              ),
            ],
          ),
          SizedBox(height: 24.spMin),
          Consumer<LoginViewModel>(
            builder: (context, vm, _) {
              return ElevatedButton(
                onPressed: vm.isLoading ? null : onLoginSubmit,
                child: vm.isLoading
                    ? SizedBox(
                        width: 20.spMin,
                        height: 20.spMin,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Sign In to LinkDesk',
                        style: tsS14W600.copyWith(color: Colors.white),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

