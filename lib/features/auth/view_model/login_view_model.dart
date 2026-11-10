import 'package:flutter/material.dart';
import '../../../providers/view_model.dart';
import '../../../services/web_api_services.dart';
import '../../../utils/extensions.dart';
import '../repo/auth_repo.dart';

class LoginViewModel extends ViewModel {
  final TextEditingController emailController =
      TextEditingController(text: 'admin@linkdesk.io');
  final TextEditingController passwordController =
      TextEditingController(text: 'admin123');

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;

  bool _rememberMe = true;
  bool get rememberMe => _rememberMe;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  Future<bool> login() async {
    _errorMessage = null;
    notifyListeners();

    try {
      await WebAPIService()
          .loginApi(
            email: emailController.text.trim(),
            password: passwordController.text,
            rememberMe: _rememberMe,
          )
          .setProgress(this);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await WebAPIService()
        .sendPasswordResetEmailApi(email)
        .setProgress(this);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

