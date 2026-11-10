import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/web_api_services.dart';

extension AuthRepoExtension on WebAPIService {
  Future<UserModel> loginApi({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Simulated API call via WebAPIService
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: email.split('@').first.toUpperCase(),
      role: 'Super Administrator',
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );

    await AuthService().setSession(
      user: user,
      token: user.token!,
      remember: rememberMe,
    );

    await WebAPIService().initTokenToHeader();
    return user;
  }

  Future<void> logoutApi() async {
    await Future.delayed(const Duration(milliseconds: 250));
    await AuthService().clearSession();
  }

  Future<bool> sendPasswordResetEmailApi(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!email.contains('@')) {
      throw Exception('Please provide a valid email address');
    }
    return true;
  }
}
