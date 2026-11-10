import 'package:flutter/material.dart';
import '../utils/enums.dart';

class AppConfig {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static bool isDebugMode = true;
  static EnumBuildEnvironment server = EnumBuildEnvironment.dg;
}
