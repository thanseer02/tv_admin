import '../models/user_model.dart';

/// Central state storage and token management.
/// Keeps session tokens ready for future HTTP Bearer headers.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;
  String? _authToken;
  bool _rememberMe = false;

  UserModel? get currentUser => _currentUser;
  String? get authToken => _authToken;
  bool get isAuthenticated => _authToken != null && _currentUser != null;
  bool get rememberMe => _rememberMe;

  /// Set the authenticated session
  void setSession({
    required UserModel user,
    required String token,
    bool remember = false,
  }) {
    _currentUser = user;
    _authToken = token;
    _rememberMe = remember;
  }

  /// Clear the session upon logout
  void clearSession() {
    _currentUser = null;
    _authToken = null;
    _rememberMe = false;
  }
}

