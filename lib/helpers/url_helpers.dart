import '../configs/app_configs.dart';
import '../utils/enums.dart';

class UrlHelpers {
  static EnumBuildEnvironment get server => AppConfig.server;

  static String get baseURL {
    switch (server) {
      case EnumBuildEnvironment.live:
        return 'https://api.linkdesk.io/api/v1/';
      case EnumBuildEnvironment.uat:
        return 'https://uat-api.linkdesk.io/api/v1/';
      case EnumBuildEnvironment.dg:
        return 'http://localhost:8000/api/v1/';
    }
  }
}

