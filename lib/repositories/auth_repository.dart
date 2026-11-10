import '../models/user_model.dart';
import '../services/auth_service.dart';

/// Contract for Authentication repository
abstract class AuthRepository {
  Future<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  });

  Future<void> logout();

  Future<bool> sendPasswordResetEmail(String email);
}

/// Mock implementation of AuthRepository with API-ready structure
class MockAuthRepository implements AuthRepository {
  final AuthService _authService = AuthService();

  @override
  Future<UserModel> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // Mock successful authentication
    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: email.split('@').first.toUpperCase(),
      role: 'Super Administrator',
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );

    _authService.setSession(
      user: user,
      token: user.token!,
      remember: rememberMe,
    );

    return user;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _authService.clearSession();
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!email.contains('@')) {
      throw Exception('Please provide a valid email address');
    }
    return true;
  }
}

