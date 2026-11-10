import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/app_configs.dart';
import 'features/auth/view/login_screen.dart';
import 'features/dashboard/view/dashboard_screen.dart';
import 'providers/theme_provider.dart';
import 'services/auth_service.dart';
import 'utils/routes.dart';
import 'utils/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      navigatorKey: AppConfig.navKey,
      title: 'LinkDesk - URL Admin Portal',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      initialRoute: AuthService().isAuthenticated
          ? DashboardScreen.routeName
          : LoginScreen.routeName,
      onGenerateRoute: onAppGenerateRoute(),
      routes: appRoutes(),
    );
  }
}
