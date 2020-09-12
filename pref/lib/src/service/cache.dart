// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'base.dart';

class PrefServiceCache extends BasePrefService {
  PrefServiceCache({
    Map<String, dynamic> cache,
    Map<String, dynamic> defaults,
  }) : _cache = cache ?? <String, dynamic>{} {
    if (defaults != null) {
      _cache.addAll(defaults);
    }
  }

  final Map<String, dynamic> _cache;

  @override
  FutureOr<bool> set<T>(String key, T val) {
    _cache[key] = val;
    return super.set<T>(key, val);
  }

  @override
  T get<T>(String key) => _cache[key];

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
