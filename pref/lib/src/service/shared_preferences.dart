// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base.dart';

class PrefServiceShared extends BasePrefService {
  PrefServiceShared._(this.prefix, this.sharedPreferences);

  static Future<PrefServiceShared> init({
    String prefix = '',
    Map<String, dynamic>? defaults,
  }) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final instance = PrefServiceShared._(prefix, sharedPreferences);
    if (defaults != null) {
      await instance.setDefaultValues(defaults);
    }
    return instance;
  }

  final SharedPreferences sharedPreferences;

  final String prefix;

  @override
  FutureOr<bool> put<T>(String key, T val) async {
    if (val == null) {
      return remove(key);
    } else if (val is bool) {
      if (await sharedPreferences.setBool('$prefix$key', val)) {
        return super.put<T>(key, val);
      }
    } else if (val is double) {
      if (await sharedPreferences.setDouble('$prefix$key', val)) {
        return super.put<T>(key, val);
      }
    } else if (val is int) {
      if (await sharedPreferences.setInt('$prefix$key', val)) {
        return super.put<T>(key, val);
      }
    } else if (val is String) {
      if (await sharedPreferences.setString('$prefix$key', val)) {
        return super.put<T>(key, val);
      }
    } else if (val is List<String>) {
      if (await sharedPreferences.setStringList('$prefix$key', val)) {
        return super.set<T>(key, val);
      }
    }
    return false;
  }

  @override
  T? get<T>(String key) {
    return sharedPreferences.get('$prefix$key') as T?;
  }

  @override
  List<String>? getStringList(String key) {
    return sharedPreferences.getStringList('$prefix$key');
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('prefix', prefix));
  }
}
