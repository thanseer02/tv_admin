import 'package:flutter/material.dart';
import '../../../configs/app_configs.dart';
import '../../../providers/view_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/web_api_services.dart';
import '../../auth/view/login_screen.dart';
import '../../dashboard/view/dashboard_screen.dart';

class SplashViewModel extends ViewModel {
  Future<void> decideNavigation(BuildContext context) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));

      final hasStoredSession = await AuthService().initSessionFromStorage();
      if (hasStoredSession) {
        await WebAPIService().initTokenToHeader();
      }

      final targetRoute = AuthService().isAuthenticated
          ? DashboardScreen.routeName
          : LoginScreen.routeName;

      // Use AppConfig.navKey if context is unmounted
      final navState = AppConfig.navKey.currentState ?? (context.mounted ? Navigator.of(context) : null);
      navState?.pushReplacementNamed(targetRoute);
    } catch (e) {
      debugPrint('Navigation error in SplashViewModel: $e');
      final navState = AppConfig.navKey.currentState ?? (context.mounted ? Navigator.of(context) : null);
      navState?.pushReplacementNamed(LoginScreen.routeName);
    }
  }
}
