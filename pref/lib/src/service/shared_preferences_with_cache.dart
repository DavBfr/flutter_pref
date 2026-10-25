// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base.dart';

class PrefServiceSharedWithCache extends BasePrefService {
  PrefServiceSharedWithCache._(this.prefix, this.sharedPreferences);

  static Future<PrefServiceSharedWithCache> init({
    String prefix = '',
    Map<String, dynamic>? defaults,
    SharedPreferencesOptions sharedPreferencesOptions =
        const SharedPreferencesOptions(),
    SharedPreferencesWithCacheOptions cacheOptions =
        const SharedPreferencesWithCacheOptions(),
  }) async {
    final sharedPreferences = await SharedPreferencesWithCache.create(
      sharedPreferencesOptions: sharedPreferencesOptions,
      cacheOptions: cacheOptions,
    );
    final instance = PrefServiceSharedWithCache._(prefix, sharedPreferences);
    if (defaults != null) {
      await instance.setDefaultValues(defaults);
    }
    return instance;
  }

  final SharedPreferencesWithCache sharedPreferences;

  final String prefix;

  @override
  FutureOr<bool> put<T>(String key, T val) async {
    if (val == null) {
      return remove(key);
    } else if (val is bool) {
      await sharedPreferences.setBool('$prefix$key', val);
    } else if (val is double) {
      await sharedPreferences.setDouble('$prefix$key', val);
    } else if (val is int) {
      await sharedPreferences.setInt('$prefix$key', val);
    } else if (val is String) {
      await sharedPreferences.setString('$prefix$key', val);
    } else if (val is List<String>) {
      await sharedPreferences.setStringList('$prefix$key', val);
    }
    return super.put<T>(key, val);
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
      return sharedPreferences.keys;
    }

    final result = <String>{};
    for (final key in sharedPreferences.keys) {
      if (key.startsWith(prefix)) {
        result.add(key.substring(prefix.length));
      }
    }

    return result;
  }

  @override
  FutureOr<bool> remove(String key) async {
    await sharedPreferences.remove('$prefix$key');
    return super.remove(key);
  }

  @override
  FutureOr<bool> clear() async {
    if (prefix == '') {
      await sharedPreferences.clear();
    } else {
      for (final key in sharedPreferences.keys) {
        if (key.startsWith(prefix)) {
          await sharedPreferences.remove(key);
        }
      }
    }

    super.clear();
    return true;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('prefix', prefix));
  }
}
