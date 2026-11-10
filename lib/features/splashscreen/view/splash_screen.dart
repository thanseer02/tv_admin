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
      create: (_) => SplashViewModel(),
      child: const _SplashBodyWidget(),
    );
  }
}

class _SplashBodyWidget extends StatefulWidget {
  const _SplashBodyWidget();

  @override
  State<_SplashBodyWidget> createState() => _SplashBodyWidgetState();
}

class _SplashBodyWidgetState extends State<_SplashBodyWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SplashViewModel>().decideNavigation(context);
      }
    });
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

