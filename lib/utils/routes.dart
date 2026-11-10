import 'package:flutter/material.dart';
import '../features/auth/view/login_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';
import '../features/splashscreen/view/splash_screen.dart';

Map<String, Widget Function(BuildContext context)> appRoutes() => {
      SplashScreen.routeName: (context) => const SplashScreen(),
      LoginScreen.routeName: (context) => const LoginScreen(),
      DashboardScreen.routeName: (context) => const DashboardScreen(),
    };

RouteFactory onAppGenerateRoute() => (settings) {
      return null;
    };

