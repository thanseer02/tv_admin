import 'package:adaptive_theme/adaptive_theme.dart';
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      builder: (context, _) {
        return AdaptiveTheme(
          initial: AdaptiveThemeMode.dark,
          light: appLightTheme,
          dark: appDarkTheme,
          builder: (theme, darkTheme) {
            return MaterialApp(
              navigatorKey: AppConfig.navKey,
              title: 'LinkDesk - URL Admin Portal',
              debugShowCheckedModeBanner: false,
              themeMode: context.watch<ThemeProvider>().themeMode,
              theme: theme,
              darkTheme: darkTheme,
              initialRoute: AuthService().isAuthenticated
                  ? DashboardScreen.routeName
                  : LoginScreen.routeName,
              onGenerateRoute: onAppGenerateRoute(),
              routes: appRoutes(),
            );
          },
        );
      },
    );
  }
}
