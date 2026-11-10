import '../helpers/url_helpers.dart';

String urlBase = UrlHelpers.baseURL;

// Authentication
String urlLogin = '${urlBase}auth/login';
String urlLogout = '${urlBase}auth/logout';
String urlGetMe = '${urlBase}auth/me';

// URLs Management
String urlGetUrls = '${urlBase}urls';
String urlAddUrl = '${urlBase}urls';
String urlUpdateUrl(String id) => '${urlBase}urls/$id';
String urlDeleteUrl(String id) => '${urlBase}urls/$id';
String urlToggleStatusUrl(String id) => '${urlBase}urls/$id/toggle-status';

