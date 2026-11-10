import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../utils/styles.dart';
import '../../dashboard/view/dashboard_screen.dart';
import '../view_model/login_view_model.dart';
import '../widgets/auth_brand_header_widget.dart';
import '../widgets/login_form_widget.dart';

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
    final formKey = GlobalKey<FormState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.spMin),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 440.spMin),
            child: Card(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.spMin, vertical: 40.spMin),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AuthBrandHeaderWidget(),
                    SizedBox(height: 32.spMin),
                    LoginFormWidget(
                      formKey: formKey,
                      onLoginSubmit: () async {
                        if (!formKey.currentState!.validate()) return;
                        final success = await context.read<LoginViewModel>().login();
                        if (success && context.mounted) {
                          Navigator.of(context).pushReplacementNamed(DashboardScreen.routeName);
                        }
                      },
                    ),
                    SizedBox(height: 20.spMin),
                    Container(
                      padding: EdgeInsets.all(10.spMin),
                      decoration: BoxDecoration(
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(8.spMin),
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
    );
  }
}
