import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/splash_view_model.dart';
import '../widgets/splash_brand_widget.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = '/SplashScreen';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) {
        final vm = SplashViewModel();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          vm.decideNavigation(ctx);
        });
        return vm;
      },
      child: const Scaffold(
        body: Center(
          child: SplashBrandWidget(),
        ),
      ),
    );
  }
}
