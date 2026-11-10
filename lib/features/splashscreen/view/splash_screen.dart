import 'dart:async';
import 'package:flutter/material.dart';
import '../../../services/auth_service.dart';
import '../../../services/web_api_services.dart';
import '../../auth/view/login_screen.dart';
import '../../dashboard/view/dashboard_screen.dart';
import '../widgets/splash_brand_widget.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startNavigation();
  }

  Future<void> _startNavigation() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      final hasSession = await AuthService().initSessionFromStorage();
      if (hasSession) {
        await WebAPIService().initTokenToHeader();
      }

      if (!mounted) return;

      final target = AuthService().isAuthenticated
          ? DashboardScreen.routeName
          : LoginScreen.routeName;

      Navigator.of(context).pushReplacementNamed(target);
    } catch (e) {
      debugPrint('Splash navigation error: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SplashBrandWidget(),
      ),
    );
  }
}

