import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/styles.dart';
import '../view_model/login_view_model.dart';
import '../widgets/forgot_password_dialog_widget.dart';
import '../../dashboard/view/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: const _LoginContent(),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6366F1).withValues(alpha: 0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.link_rounded, color: Colors.white, size: 30),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'LinkDesk',
                        textAlign: TextAlign.center,
                        style: tsS26W700.copyWith(letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'URL Management & Streaming Admin Portal',
                        textAlign: TextAlign.center,
                        style: tsS13W600.copyWith(
                          fontWeight: FontWeight.normal,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Consumer<LoginViewModel>(
                        builder: (context, vm, _) {
                          if (vm.errorMessage == null) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                                  const SizedBox(width: 8),
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
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            prefixIcon: Icon(Icons.email_outlined, size: 20),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Enter email address';
                            if (!val.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 18),
                      Consumer<LoginViewModel>(
                        builder: (context, vm, _) => TextFormField(
                          controller: vm.passwordController,
                          obscureText: vm.obscurePassword,
                          style: tsS14W400,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(
                                vm.obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                size: 20,
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
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: Consumer<LoginViewModel>(
                                  builder: (context, vm, _) => Checkbox(
                                    value: vm.rememberMe,
                                    onChanged: (v) => context.read<LoginViewModel>().setRememberMe(v ?? false),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('Remember me', style: tsS13W600.copyWith(fontWeight: FontWeight.normal)),
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
                      const SizedBox(height: 24),
                      Consumer<LoginViewModel>(
                        builder: (context, vm, _) {
                          return ElevatedButton(
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                                    if (!formKey.currentState!.validate()) return;
                                    final success = await context.read<LoginViewModel>().login();
                                    if (success && context.mounted) {
                                      Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
                                    }
                                  },
                            child: vm.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text('Sign In to LinkDesk', style: tsS14W600.copyWith(color: Colors.white)),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '💡 Demo Credentials pre-filled. MVVM Architecture ready for API.',
                          textAlign: TextAlign.center,
                          style: tsS11W600.copyWith(color: Colors.grey, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
