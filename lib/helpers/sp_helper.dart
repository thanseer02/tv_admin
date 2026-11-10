import 'package:shared_preferences/shared_preferences.dart';

class SpHelper {
  static SharedPreferences? _sp;

  static Future<SharedPreferences> getSP() async {
    _sp ??= await SharedPreferences.getInstance();
    await _sp!.reload();
    return _sp!;
  }

  static Future<bool> saveString(String key, String value) async {
    final sp = await getSP();
    return await sp.setString(key, value);
  }

  static Future<bool?> clearAll() async {
    final sp = await getSP();
    return await sp.clear();
  }

  static Future<String?> getString(String key) async {
    final sp = await getSP();
    return sp.getString(key);
  }

  static Future<bool?> getBoolean(String key) async {
    final sp = await getSP();
    return sp.getBool(key);
  }

  static Future<bool> saveBoolean(String key, bool value) async {
    final sp = await getSP();
    return await sp.setBool(key, value);
  }
}

