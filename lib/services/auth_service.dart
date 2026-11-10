import '../helpers/sp_helper.dart';
import '../models/user_model.dart';
import '../utils/sp_keys.dart';

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

  Future<void> setSession({
    required UserModel user,
    required String token,
    bool remember = false,
  }) async {
    _currentUser = user;
    _authToken = token;
    _rememberMe = remember;

    if (remember) {
      await SpHelper.saveString(keyToken, token);
      await SpHelper.saveString(keyEmail, user.email);
      await SpHelper.saveString(keyUserName, user.name);
      await SpHelper.saveString(keyRole, user.role);
      await SpHelper.saveBoolean(keyRememberMe, true);
    }
  }

  Future<void> clearSession() async {
    _currentUser = null;
    _authToken = null;
    _rememberMe = false;
    await SpHelper.clearAll();
  }
}
