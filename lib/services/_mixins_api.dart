import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/enums.dart';
import '../utils/exceptions.dart';
import '../utils/sp_keys.dart' as sp_keys;

mixin WebAPIMixin {
  Future<String?> getTokenFromSharedPref() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(sp_keys.keyToken);
  }

  void onDioErrorHandling({
    required DioException error,
    required String apiName,
    VoidCallback? apiFunction,
  }) {
    debugPrint('Dio Error on $apiName: ${error.message}');
    throw APIException(
      enumProperty: EnumAPIExceptions.httpStatusError,
      message: error.message ?? EnumErrorMessage.unknownNetworkError.message,
    );
  }
}

