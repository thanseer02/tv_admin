import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'repositories/auth_repository.dart';
import 'repositories/url_repository.dart';
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LinkDeskApp());
}

/// Root Application Widget managing ThemeMode and Authentication Route
class LinkDeskApp extends StatefulWidget {
  const LinkDeskApp({super.key});

  @override
  State<LinkDeskApp> createState() => _LinkDeskAppState();
}

class _LinkDeskAppState extends State<LinkDeskApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  final AuthRepository _authRepository = MockAuthRepository();
  final UrlRepository _urlRepository = MockUrlRepository();

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _handleLoginSuccess() {
    setState(() {});
  }

  void _handleLogout() async {
    await _authRepository.logout();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated = AuthService().isAuthenticated;

    return MaterialApp(
      title: 'LinkDesk - URL Admin Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: isAuthenticated
          ? DashboardScreen(
              urlRepository: _urlRepository,
              authRepository: _authRepository,
              isDarkMode: _themeMode == ThemeMode.dark,
              onToggleTheme: _toggleTheme,
              onLogout: _handleLogout,
            )
          : LoginScreen(
              authRepository: _authRepository,
              onLoginSuccess: _handleLoginSuccess,
            ),
    );
  }
}

