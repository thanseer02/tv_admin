import 'package:flutter/material.dart';
import '../../../providers/view_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/web_api_services.dart';
import '../../auth/view/login_screen.dart';
import '../../dashboard/view/dashboard_screen.dart';

class SplashViewModel extends ViewModel {
  Future<void> decideNavigation(BuildContext context) async {
    // Artificial minimum delay for smooth branding display
    await Future.delayed(const Duration(milliseconds: 1200));

    final hasStoredSession = await AuthService().initSessionFromStorage();
    if (hasStoredSession) {
      await WebAPIService().initTokenToHeader();
    }

    if (!context.mounted) return;

    if (AuthService().isAuthenticated) {
      Navigator.pushReplacementNamed(context, DashboardScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }
}
