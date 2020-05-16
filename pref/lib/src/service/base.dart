// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';

abstract class BasePrefService extends ChangeNotifier {
  final _keyListeners = <String, Set<VoidCallback>>{};

  void addKeyListener(String key, VoidCallback f) {
    if (_keyListeners[key] == null) {
      _keyListeners[key] = <VoidCallback>{};
    }
    _keyListeners[key].add(f);
  }

  void removeKeyListener(String key, VoidCallback f) {
    _keyListeners[key]?.remove(f);
  }

  @override
  void dispose() {
    _keyListeners.clear();
    super.dispose();
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

  Future<void> apply(BasePrefService other) async {
    for (final key in other.getKeys()) {
      final dynamic val = other.get(key);
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

    if (_keyListeners[key] != null) {
      final localListeners = List<VoidCallback>.from(_keyListeners[key]);

      for (final listener in localListeners) {
        try {
          if (_keyListeners[key].contains(listener)) {
            listener();
          }
        } catch (exception, stack) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: exception,
              stack: stack,
              library: 'pref',
              context: ErrorDescription(
                  'while dispatching notifications for $runtimeType'),
            ),
          );
        }
      }
    }

    notifyListeners();
  }

  @override
  String toString() => toMap().toString();

  bool getBool(String key);

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
