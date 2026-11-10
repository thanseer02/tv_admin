import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'configs/app_configs.dart';
import 'features/splashscreen/view/splash_screen.dart';
import 'providers/theme_provider.dart';
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

    return ScreenUtilInit(
      designSize: const Size(1440, 900),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
        navigatorKey: AppConfig.navKey,
        title: 'LinkDesk - URL Admin Portal',
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: appLightTheme,
        darkTheme: appDarkTheme,
        initialRoute: SplashScreen.routeName,
        onGenerateRoute: onAppGenerateRoute(),
        routes: appRoutes(),
      ),
    );
  }
}
