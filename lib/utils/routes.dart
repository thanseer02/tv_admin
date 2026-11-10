import 'package:flutter/material.dart';
import '../features/auth/view/login_screen.dart';
import '../features/dashboard/view/dashboard_screen.dart';

Map<String, Widget Function(BuildContext context)> appRoutes() => {
      LoginScreen.routeName: (context) => const LoginScreen(),
      DashboardScreen.routeName: (context) => const DashboardScreen(),
    };

RouteFactory onAppGenerateRoute() => (settings) {
      final routes = appRoutes();
      final builder = routes[settings.name];
      if (builder != null) {
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, __, ___) => builder(context),
          transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
        );
      }
      return null;
    };

