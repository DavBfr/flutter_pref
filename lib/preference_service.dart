import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static SharedPreferences sharedPreferences;
  static String prefix = '';

  static Future<bool> init({String prefix = ''}) async {
    PrefService.prefix = prefix;
    if (sharedPreferences != null) return false;
    sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }

  static bool getBool(String key) {
    checkInit();
    if (key.startsWith('!')) {
      return !sharedPreferences.getBool('$prefix${key.substring(1)}');
    }
    return sharedPreferences.getBool('$prefix$key');
  }

  static setBool(String key, bool val) {
    checkInit();
    sharedPreferences.setBool('$prefix$key', val);
  }

  static String getString(String key) {
    checkInit();
    return sharedPreferences.getString('$prefix$key');
  }

  static setString(String key, String val) {
    checkInit();
    sharedPreferences.setString('$prefix$key', val);
  }

  static int getInt(String key) {
    checkInit();
    return sharedPreferences.getInt('$prefix$key');
  }

  static setInt(String key, int val) {
    checkInit();
    sharedPreferences.setInt('$prefix$key', val);
  }

  static double getDouble(String key) {
    checkInit();
    return sharedPreferences.getDouble('$prefix$key');
  }

  static setDouble(String key, double val) {
    checkInit();
    sharedPreferences.setDouble('$prefix$key', val);
  }

  static get(String key) {
    checkInit();
    return sharedPreferences.get('$prefix$key');
  }

  static Set<String> getKeys() {
    checkInit();
    return sharedPreferences.getKeys();
  }

  static Map subs = {};
  static void notify(String key) {
    if (subs[key] == null) return;

    for (Function f in subs[key]) {
      f();
    }
  }

  static void onNotify(String key, Function f) {
    if (subs[key] == null) subs[key] = [];
    subs[key].add(f);
  }

  static void showError(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static checkInit() {
    if (sharedPreferences == null) throw Exception('''\n
  PrefService not initialized.
  Call await PrefService.init() before any other PrefService call.
          
  main() async {
    await PrefService.init();
    runApp(MyApp());
  }
      ''');
  }
}
