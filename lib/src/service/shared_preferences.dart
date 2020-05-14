// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import 'base.dart';

class SharedPrefService extends BasePrefService {
  SharedPrefService._(this.prefix, this.sharedPreferences)
      : assert(prefix != null),
        assert(sharedPreferences != null);

  final SharedPreferences sharedPreferences;

  final String prefix;

  static Future<SharedPrefService> init({String prefix = ''}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return SharedPrefService._(prefix, sharedPreferences);
  }

  @override
  bool getBoolRaw(String key) {
    return sharedPreferences.getBool('$prefix$key');
  }

  @override
  FutureOr<bool> setBool(String key, bool val) async {
    if (await sharedPreferences.setBool('$prefix$key', val)) {
      return super.setBool(key, val);
    }
    return false;
  }

  @override
  String getString(String key) {
    return sharedPreferences.getString('$prefix$key');
  }

  @override
  FutureOr<bool> setString(String key, String val) async {
    if (await sharedPreferences.setString('$prefix$key', val)) {
      return super.setString(key, val);
    }

    return false;
  }

  @override
  int getInt(String key) {
    return sharedPreferences.getInt('$prefix$key');
  }

  @override
  FutureOr<bool> setInt(String key, int val) async {
    if (await sharedPreferences.setInt('$prefix$key', val)) {
      super.setInt(key, val);
    }

    return false;
  }

  @override
  double getDouble(String key) {
    return sharedPreferences.getDouble('$prefix$key');
  }

  @override
  FutureOr<bool> setDouble(String key, double val) async {
    if (await sharedPreferences.setDouble('$prefix$key', val)) {
      return super.setDouble(key, val);
    }

    return false;
  }

  @override
  List<String> getStringList(String key) {
    return sharedPreferences.getStringList('$prefix$key');
  }

  @override
  FutureOr<bool> setStringList(String key, List<String> val) async {
    if (await sharedPreferences.setStringList('$prefix$key', val)) {
      return super.setStringList(key, val);
    }
    return false;
  }

  @override
  dynamic get(String key) {
    return sharedPreferences.get('$prefix$key');
  }

  @override
  Set<String> getKeys() {
    if (prefix == '') {
      return sharedPreferences.getKeys();
    }

    final result = <String>{};
    for (final key in sharedPreferences.getKeys()) {
      if (key.startsWith(prefix)) {
        result.add(key.substring(prefix.length));
      }
    }

    return result;
  }

  @override
  FutureOr<bool> remove(String key) async {
    if (await sharedPreferences.remove('$prefix$key')) {
      return super.remove(key);
    }
    return false;
  }

  @override
  FutureOr<bool> clear() async {
    var result = true;
    if (prefix == '') {
      result = await sharedPreferences.clear();
    } else {
      for (final key in sharedPreferences.getKeys()) {
        if (key.startsWith(prefix)) {
          if (!await sharedPreferences.remove('$prefix$key')) {
            result = false;
          }
        }
      }
    }

    super.clear();
    return result;
  }
}
