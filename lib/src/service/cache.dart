// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'base.dart';

class PrefServiceCache extends BasePrefService {
  final _cache = <String, dynamic>{};

  @override
  bool getBoolRaw(String key) {
    return _cache[key];
  }

  @override
  FutureOr<bool> setBool(String key, bool val) {
    _cache[key] = val;
    return super.setBool(key, val);
  }

  @override
  String getString(String key) {
    return _cache[key];
  }

  @override
  FutureOr<bool> setString(String key, String val) {
    _cache[key] = val;
    return super.setString(key, val);
  }

  @override
  int getInt(String key) {
    return _cache[key];
  }

  @override
  FutureOr<bool> setInt(String key, int val) {
    _cache[key] = val;
    return super.setInt(key, val);
  }

  @override
  double getDouble(String key) {
    return _cache[key];
  }

  @override
  FutureOr<bool> setDouble(String key, double val) {
    _cache[key] = val;
    return super.setDouble(key, val);
  }

  @override
  List<String> getStringList(String key) {
    return _cache[key];
  }

  @override
  FutureOr<bool> setStringList(String key, List<String> val) {
    _cache[key] = val;
    return super.setStringList(key, val);
  }

  @override
  dynamic get(String key) {
    return _cache[key];
  }

  @override
  Set<String> getKeys() {
    return Set<String>.from(_cache.keys);
  }

  @override
  FutureOr<bool> remove(String key) async {
    _cache.remove(key);
    return super.remove(key);
  }

  @override
  void clear() {
    _cache.clear();
    super.clear();
  }
}
