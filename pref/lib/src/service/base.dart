// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:core';

import 'package:flutter/foundation.dart';

import '../log.dart';

/// Base class for the preferences storage
abstract class BasePrefService extends ChangeNotifier
    with DiagnosticableTreeMixin {
  final _keyListeners = <String, Set<VoidCallback>>{};
  final _secretKeys = <String>{};

  /// Add a ChangeNotifier to this key
  void addKeyListener(String key, VoidCallback f) {
    if (_keyListeners[key] == null) {
      _keyListeners[key] = <VoidCallback>{};
    }
    _keyListeners[key]!.add(f);
  }

  /// Remove a ChangeNotifier to this key
  void removeKeyListener(String key, VoidCallback f) {
    _keyListeners[key]?.remove(f);
  }

  /// Get a stream on the preference changes
  Stream<T> stream<T>(String key) {
    late StreamController<T> controller;

    void emit() {
      try {
        final value = get<T>(key);
        if (value != null) {
          controller.add(value);
        }
      } catch (e) {
        controller.addError(e);
      }
    }

    void listen() {
      emit();
      addKeyListener(key, emit);
    }

    void done() {
      removeKeyListener(key, emit);
    }

    controller = StreamController<T>(
      onListen: listen,
      onResume: listen,
      onPause: done,
      onCancel: () {
        done();
        controller.close();
      },
    );

    return controller.stream;
  }

  @override
  void dispose() {
    _keyListeners.clear();
    super.dispose();
  }

  /// Set the default preference values
  Future<bool> setDefaultValues(Map<String, dynamic> values) async {
    var result = true;
    final keys = getKeys();
    for (final key in values.keys) {
      if (!keys.contains(key)) {
        if (!await put<dynamic>(key, values[key])) {
          result = false;
        }
      } else {
        final dynamic value = get<dynamic>(key);

        if (value is List) {
          if (values[key] is! List) {
            if (!await put<dynamic>(key, values[key])) {
              result = false;
            }
          }
        } else if (value.runtimeType != values[key].runtimeType) {
          if (!await put<dynamic>(key, values[key])) {
            result = false;
          }
        }
      }
    }

    return result;
  }

  /// Merge the preference values from [other]
  Future<void> apply(BasePrefService other) async {
    for (final key in other.getKeys()) {
      final dynamic val = other.get<dynamic>(key);
      await set<dynamic>(key, val);
    }
  }

  /// Export the preference values to a [Map]
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    for (final key in getKeys()) {
      result[key] = get<dynamic>(key);
    }
    return result;
  }

  /// Import the preference values from a [Map]
  Future<void> fromMap(Map<String, dynamic> map) async {
    for (final key in map.keys) {
      await set<dynamic>(key, map[key]);
    }
  }

  /// Set a preference value, always trigger a change
  @mustCallSuper
  FutureOr<bool> put<T>(String key, T val) {
    _changed<T>(key, val);
    return true;
  }

  /// Set a preference value if it has changed
  @nonVirtual
  FutureOr<bool> set<T>(String key, T val) {
    if (get<dynamic>(key) == val) {
      return true;
    }
    return put(key, val);
  }

  /// Register this preference as secret/confidential and do not log the value
  /// displays <XXXXXXX> instead
  void makeSecret(String key) {
    _secretKeys.add(key);
  }

  /// Mark all preferences as secret/confidential.
  void makeAllSecret(Iterable<String> keys) {
    _secretKeys.addAll(keys);
  }

  /// Is this preference a secret value?
  bool isSecret(String key) {
    return _secretKeys.contains(key);
  }

  void _changed<T>(String key, T val) {
    if (isSecret(key)) {
      logger.fine('$runtimeType set $key to <XXXXXXX>');
    } else {
      logger.fine('$runtimeType set $key to "$val"');
    }

    if (_keyListeners[key] != null) {
      final localListeners = List<VoidCallback>.from(_keyListeners[key]!);

      for (final listener in localListeners) {
        try {
          if (_keyListeners[key]!.contains(listener)) {
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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    for (final key in getKeys().toList()..sort()) {
      final dynamic value = get<dynamic>(key);
      if (value is int) {
        properties.add(IntProperty(key, value));
      } else if (value is double) {
        properties.add(DoubleProperty(key, value));
      } else if (value is String) {
        properties.add(StringProperty(key, value));
      } else if (value is Enum) {
        properties.add(EnumProperty(key, value));
      } else {
        properties.add(DiagnosticsProperty(key, value));
      }
    }
  }

  /// Get a preference value
  T? get<T>(String key);

  /// Get a set of string values
  List<String>? getStringList(String key);

  /// Get all preference keys
  Set<String> getKeys();

  /// Remove the value for a preference
  @mustCallSuper
  FutureOr<bool> remove(String key) async {
    _changed(key, null);
    return true;
  }

  /// Clear all values
  @mustCallSuper
  void clear() {
    logger.fine('$runtimeType clear');
  }
}
