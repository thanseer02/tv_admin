import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/web_api_services.dart';
import '../../../utils/urls.dart';

extension AuthRepoExtension on WebAPIService {
  Future<UserModel> loginApi({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      final response = await dio.post(
        urlLogin,
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      final data = response.data;
      if (data == null || data['success'] != true) {
        throw Exception(data?['message'] ?? 'Login failed');
      }

      final userData = data['user'] as Map<String, dynamic>;
      final token = data['token'] as String;

      final user = UserModel.fromJson({
        ...userData,
        'token': token,
      });

      await AuthService().setSession(
        user: user,
        token: token,
        remember: rememberMe,
      );

      await WebAPIService().initTokenToHeader();
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logoutApi() async {
    try {
      await dio.post(urlLogout);
    } catch (_) {}
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
