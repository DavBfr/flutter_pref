// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'base.dart';

class ProxyPrefService with DiagnosticableTreeMixin implements BasePrefService {
  const ProxyPrefService(this._proxy);

  final BasePrefService _proxy;

  @override
  void addKeyListener(String key, VoidCallback f) {
    _proxy.addKeyListener(key, f);
  }

  @override
  void addListener(VoidCallback listener) {
    _proxy.addListener(listener);
  }

  @override
  Future<void> apply(BasePrefService other) {
    return _proxy.apply(other);
  }

  @override
  void clear() {
    _proxy.clear();
  }

  @override
  void dispose() {
    _proxy.dispose();
  }

  @override
  Future<void> fromMap(Map<String, dynamic> map) {
    return _proxy.fromMap(map);
  }

  @override
  T? get<T>(String key) {
    return _proxy.get<T>(key);
  }

  @override
  Set<String> getKeys() {
    return _proxy.getKeys();
  }

  @override
  bool get hasListeners => _proxy.hasListeners;

  @override
  bool isSecret(String key) {
    return _proxy.isSecret(key);
  }

  @override
  void makeAllSecret(Iterable<String> keys) {
    _proxy.makeAllSecret(keys);
  }

  @override
  void makeSecret(String key) {
    _proxy.makeSecret(key);
  }

  @override
  void notifyListeners() {
    _proxy.notifyListeners();
  }

  @override
  FutureOr<bool> remove(String key) {
    return _proxy.remove(key);
  }

  @override
  void removeKeyListener(String key, VoidCallback f) {
    _proxy.removeKeyListener(key, f);
  }

  @override
  void removeListener(VoidCallback listener) {
    _proxy.removeListener(listener);
  }

  @override
  FutureOr<bool> set<T>(String key, T val) {
    return _proxy.set<T>(key, val);
  }

  @override
  Future<bool> setDefaultValues(Map<String, dynamic> values) {
    return _proxy.setDefaultValues(values);
  }

  @override
  Stream<T> stream<T>(String key) {
    return _proxy.stream<T>(key);
  }

  @override
  Map<String, dynamic> toMap() {
    return _proxy.toMap();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    _proxy.debugFillProperties(properties);
  }
}
