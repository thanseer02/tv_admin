import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../providers/_mixins.dart';
import '_mixins_api.dart';

class WebAPIService with WebAPIMixin, MixinAPIProvider {
  WebAPIService._initialise()
      : _dio = Dio(BaseOptions(
          headers: {"accept": "application/json"},
        )) {
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  static final WebAPIService _instance = WebAPIService._initialise();
  factory WebAPIService() => _instance;

  final Dio _dio;
  Dio get dio => _dio;

  Future<bool> initTokenToHeader({bool initToken = true}) =>
      getTokenFromSharedPref().then((token) {
        if (token?.isEmpty ?? true) return true;
        if (_dio.options.headers.containsKey('Authorization')) {
          _dio.options.headers.remove('Authorization');
        }
        if (initToken) {
          _dio.options.headers['Authorization'] = 'Bearer $token';
        }
        return true;
      });
}
