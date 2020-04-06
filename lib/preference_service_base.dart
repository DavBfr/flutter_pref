import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';

abstract class BasePrefService extends ChangeNotifier {
  final subs = <String, Set<VoidCallback>>{};

  void notify(String key) {
    if (subs[key] == null) return;

    for (Function f in subs[key]) {
      f();
    }
  }

  void onNotify(String key, VoidCallback f) {
    if (subs[key] == null) {
      subs[key] = <VoidCallback>{};
    }
    subs[key].add(f);
  }

  void onNotifyRemove(String key, VoidCallback f) {
    subs[key]?.remove(f);
  }

  Future<bool> setDefaultValues(Map<String, dynamic> values) async {
    var result = true;
    final keys = getKeys();
    for (final key in values.keys) {
      if (!keys.contains(key)) {
        if (!await set(key, values[key])) {
          result = false;
        }
      } else {
        if (get(key).runtimeType != values[key].runtimeType) {
          if (!await set(key, values[key])) {
            result = false;
          }
        }
      }
    }

    return result;
  }

  bool getBool(String key) {
    if (key.startsWith('!')) {
      final val = getBoolRaw(key.substring(1));
      if (val == null) return null;
      return !val;
    }

    return getBoolRaw(key);
  }

  Future<void> apply(BasePrefService other) async {
    for (final key in other.getKeys()) {
      final val = other.get(key);
      await set(key, val);
    }
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    for (final key in getKeys()) {
      result[key] = get(key);
    }
    return result;
  }

  Future<void> fromMap(Map<String, dynamic> map) async {
    for (final key in map.keys) {
      await set(key, map[key]);
    }
  }

  Future<bool> set(String key, dynamic val) async {
    if (val is bool) {
      return await setBool(key, val);
    } else if (val is double) {
      return await setDouble(key, val);
    } else if (val is int) {
      return await setInt(key, val);
    } else if (val is List<String>) {
      return await setStringList(key, val);
    } else if (val is String) {
      return await setString(key, val);
    }

    return false;
  }

  void _changed(String key, dynamic val) {
    assert(() {
      print('PrefService set $key to "$val"');
      return true;
    }());
    notifyListeners();
  }

  @override
  String toString() => toMap().toString();

  @protected
  bool getBoolRaw(String key);

  @mustCallSuper
  FutureOr<bool> setBool(String key, bool val) {
    _changed(key, val);
    return true;
  }

  String getString(String key);

  @mustCallSuper
  FutureOr<bool> setString(String key, String val) {
    _changed(key, val);
    return true;
  }

  int getInt(String key);

  @mustCallSuper
  FutureOr<bool> setInt(String key, int val) {
    _changed(key, val);
    return true;
  }

  double getDouble(String key);

  @mustCallSuper
  FutureOr<bool> setDouble(String key, double val) {
    _changed(key, val);
    return true;
  }

  List<String> getStringList(String key);

  @mustCallSuper
  FutureOr<bool> setStringList(String key, List<String> val) {
    _changed(key, val);
    return true;
  }

  dynamic get(String key);

  Set<String> getKeys();

  @mustCallSuper
  FutureOr<bool> remove(String key) async {
    _changed(key, null);
    return true;
  }

  @mustCallSuper
  void clear() {
    _changed(null, null);
  }
}
