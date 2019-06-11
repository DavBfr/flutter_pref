import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static SharedPreferences sharedPreferences;
  static String prefix = '';

  static bool _justCache = false;

  static Map cache;

  static Future<bool> init({String prefix = ''}) async {
    if (sharedPreferences != null) return false;
    PrefService.prefix = prefix;
    sharedPreferences = await SharedPreferences.getInstance();
    clearCache();
    return true;
  }

  static void setDefaultValues(Map values) {
    print(values);
    for (String key in values.keys) {
      if (sharedPreferences.containsKey(prefix+key)) continue;
      var val = values[key];
      if (val is bool)
        sharedPreferences.setBool(prefix+key, val);
      else if (val is double)
        sharedPreferences.setDouble(prefix+key, val);
      else if (val is int)
        sharedPreferences.setInt(prefix+key, val);
      else if (val is String)
        sharedPreferences.setString(prefix+key, val);
      else if (val is List<String>) sharedPreferences.setStringList(key, val);
    }
  }

  static bool getBool(String key) {
    checkInit();
    if (key.startsWith('!')) {
      bool val;
      if (_justCache)
        val = cache[prefix + key.substring(1)];
      else
        val = sharedPreferences.getBool('$prefix${key.substring(1)}');
      if (val == null) return null;
      return !val;
    }
    if (_justCache)
      return cache['$prefix$key'];
    else
      return sharedPreferences.getBool('$prefix$key');
  }

  static setBool(String key, bool val) {
    checkInit();
    if (_justCache)
      cache['$prefix$key'] = val;
    else
      sharedPreferences.setBool('$prefix$key', val);
  }

  static String getString(String key) {
    checkInit();
    if (_justCache)
      return cache['$prefix$key'];
    else
      return sharedPreferences.getString('$prefix$key');
  }

  static setString(String key, String val) {
    checkInit();
    if (_justCache)
      cache['$prefix$key'] = val;
    else
      sharedPreferences.setString('$prefix$key', val);
  }

  static int getInt(String key) {
    checkInit();
    if (_justCache)
      return cache['$prefix$key'];
    else
      return sharedPreferences.getInt('$prefix$key');
  }

  static setInt(String key, int val) {
    checkInit();
    if (_justCache)
      cache['$prefix$key'] = val;
    else
      sharedPreferences.setInt('$prefix$key', val);
  }

  static double getDouble(String key) {
    checkInit();
    if (_justCache)
      return cache['$prefix$key'];
    else
      return sharedPreferences.getDouble('$prefix$key');
  }

  static setDouble(String key, double val) {
    checkInit();
    if (_justCache)
      cache['$prefix$key'] = val;
    else
      sharedPreferences.setDouble('$prefix$key', val);
  }

  static List<String> getStringList(String key) {
    checkInit();
    if (_justCache)
      return cache['$prefix$key'];
    else
      return sharedPreferences.getStringList('$prefix$key');
  }

  static setStringList(String key, List<String> val) {
    checkInit();
    if (_justCache)
      cache['$prefix$key'] = val;
    else
      sharedPreferences.setStringList('$prefix$key', val);
  }

  static get(String key) {
    checkInit();
    if (_justCache)
      return cache['$prefix$key'];
    else
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

  static void onNotifyRemove(String key) {
    subs[key] = null;
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

  static void clearCache() {
    cache = {};

    for (String key in sharedPreferences.getKeys())
      cache[key] = sharedPreferences.get(key);
  }

  static void enableCaching() {
    _justCache = true;
  }

  static void disableCaching() {
    _justCache = false;
  }

  static void applyCache() {
    disableCaching();
    for (String key in cache.keys) {
      var val = cache[key];
      if (val is bool)
        sharedPreferences.setBool(key, val);
      else if (val is double)
        sharedPreferences.setDouble(key, val);
      else if (val is int)
        sharedPreferences.setInt(key, val);
      else if (val is String)
        sharedPreferences.setString(key, val);
      else if (val is List<String>) sharedPreferences.setStringList(key, val);
    }
    clearCache();
  }
}
