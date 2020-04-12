import 'dart:core';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefService extends InheritedWidget {
  const PrefService({
    Key key,
    @required Widget child,
    @required this.service,
  })  : assert(service != null),
        super(key: key, child: child);

  final BasePrefService service;

  static BasePrefService _instance;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static BasePrefService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PrefService>().service ??
      _instance;

  @Deprecated('Use PrefService as a widget instead')
  static Future<bool> init({
    @Deprecated('Use service instead') String prefix = '',
    BasePrefService service,
  }) async {
    if (service != null) {
      _instance = service;
      return true;
    }

    if (_instance != null) {
      return false;
    }

    _instance = await SharedPrefService.init(prefix: prefix);
    return true;
  }

  @Deprecated('Use PrefService.of()')
  static void setDefaultValues(Map<String, dynamic> values) {
    checkInit();
    _instance.setDefaultValues(values);
  }

  @Deprecated('Use PrefService.of()')
  static bool getBool(String key) {
    checkInit();
    return _instance.getBool(key);
  }

  @Deprecated('Use PrefService.of()')
  static FutureOr<bool> setBool(String key, bool val) {
    checkInit();
    return _instance.setBool(key, val);
  }

  @Deprecated('Use PrefService.of()')
  static String getString(String key) {
    checkInit();
    return _instance.getString(key);
  }

  @Deprecated('Use PrefService.of()')
  static FutureOr<bool> setString(String key, String val) {
    checkInit();
    return _instance.setString(key, val);
  }

  @Deprecated('Use PrefService.of()')
  static int getInt(String key) {
    checkInit();
    return _instance.getInt(key);
  }

  @Deprecated('Use PrefService.of()')
  static FutureOr<bool> setInt(String key, int val) {
    checkInit();
    return _instance.setInt(key, val);
  }

  @Deprecated('Use PrefService.of()')
  static double getDouble(String key) {
    checkInit();
    return _instance.getDouble(key);
  }

  @Deprecated('Use PrefService.of()')
  static FutureOr<bool> setDouble(String key, double val) {
    checkInit();
    return _instance.setDouble(key, val);
  }

  @Deprecated('Use PrefService.of()')
  static List<String> getStringList(String key) {
    checkInit();
    return _instance.getStringList(key);
  }

  @Deprecated('Use PrefService.of()')
  static FutureOr<bool> setStringList(String key, List<String> val) {
    checkInit();
    return _instance.setStringList(key, val);
  }

  @Deprecated('Use PrefService.of()')
  static dynamic get(String key) {
    checkInit();
    return _instance.get(key);
  }

  @Deprecated('Use PrefService.of()')
  static Set<String> getKeys() {
    checkInit();
    return _instance.getKeys();
  }

  @Deprecated('Use PrefService.of()')
  static void notify(String key) {
    checkInit();
    _instance.notify(key);
  }

  @Deprecated('Use PrefService.of()')
  static void onNotify(String key, VoidCallback f) {
    checkInit();
    _instance.onNotify(key, f);
  }

  @Deprecated('Use PrefService.of()')
  static void onNotifyRemove(String key, VoidCallback f) {
    checkInit();
    _instance.onNotifyRemove(key, f);
  }

  static void showError(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @Deprecated('Use PrefService.of()')
  static checkInit() {
    if (_instance == null) {
      throw Exception('''\n
  PrefService not initialized.
  Call await PrefService.init() before any other PrefService call.

  main() async {
    await PrefService.init();
    runApp(MyApp());
  }
      ''');
    }
  }

  @Deprecated('Use PrefService.of()')
  static void clear() {
    checkInit();
    _instance.clear();
  }

  @Deprecated('Use PrefService.of()')
  static void apply(BasePrefService other) {
    checkInit();
    _instance.apply(other);
  }

  @Deprecated('You can safely remove the call to this function')
  static void rebuildCache() {}

  @Deprecated('Use JustCachePrefService')
  static void enableCaching() {}

  @Deprecated('Use SharedPrefService')
  static void disableCaching() {}

  @Deprecated('use apply(other)')
  static Future<void> applyCache() async {}
}

abstract class BasePrefService {
  final subs = <String, Set<VoidCallback>>{};

  void notify(String key) {
    if (subs[key] == null) return;

    for (Function f in subs[key]) {
      f();
    }
  }

  void onNotify(String key, VoidCallback f) {
    if (subs[key] == null) {
      subs[key] = Set<VoidCallback>();
    }
    subs[key].add(f);
  }

  void onNotifyRemove(String key, VoidCallback f) {
    subs[key]?.remove(f);
  }

  void setDefaultValues(Map<String, dynamic> values) {
    final keys = getKeys();
    for (String key in values.keys) {
      if (keys.contains(key)) {
        continue;
      }

      var val = values[key];
      if (val is bool) {
        setBool(key, val);
      } else if (val is double) {
        setDouble(key, val);
      } else if (val is int) {
        setInt(key, val);
      } else if (val is String) {
        setString(key, val);
      } else if (val is List<String>) {
        setStringList(key, val);
      }
    }
  }

  bool getBool(String key) {
    if (key.startsWith('!')) {
      bool val = getBoolRaw(key.substring(1));
      if (val == null) return null;
      return !val;
    }

    return getBoolRaw(key);
  }

  Future<void> apply(BasePrefService other) async {
    for (String key in other.getKeys()) {
      var val = other.get(key);
      if (val is bool) {
        await setBool(key, val);
      } else if (val is double) {
        await setDouble(key, val);
      } else if (val is int) {
        await setInt(key, val);
      } else if (val is String) {
        await setString(key, val);
      } else if (val is List<String>) {
        await setStringList(key, val);
      }
    }
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    for (String key in getKeys()) {
      result[key] = get(key);
    }
    return result;
  }

  Future<void> fromMap(Map<String, dynamic> map) async {
    for (String key in map.keys) {
      var val = map[key];
      if (val is bool) {
        await setBool(key, val);
      } else if (val is double) {
        await setDouble(key, val);
      } else if (val is int) {
        await setInt(key, val);
      } else if (val is String) {
        await setString(key, val);
      } else if (val is List<String>) {
        await setStringList(key, val);
      }
    }
  }

  @protected
  bool getBoolRaw(String key);

  FutureOr<bool> setBool(String key, bool val);

  String getString(String key);

  FutureOr<bool> setString(String key, String val);

  int getInt(String key);

  FutureOr<bool> setInt(String key, int val);

  double getDouble(String key);

  FutureOr<bool> setDouble(String key, double val);

  List<String> getStringList(String key);

  FutureOr<bool> setStringList(String key, List<String> val);

  get(String key);

  Set<String> getKeys();

  void clear();
}

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
  FutureOr<bool> setBool(String key, bool val) {
    return sharedPreferences.setBool('$prefix$key', val);
  }

  @override
  String getString(String key) {
    return sharedPreferences.getString('$prefix$key');
  }

  @override
  FutureOr<bool> setString(String key, String val) {
    return sharedPreferences.setString('$prefix$key', val);
  }

  @override
  int getInt(String key) {
    return sharedPreferences.getInt('$prefix$key');
  }

  @override
  FutureOr<bool> setInt(String key, int val) {
    return sharedPreferences.setInt('$prefix$key', val);
  }

  @override
  double getDouble(String key) {
    return sharedPreferences.getDouble('$prefix$key');
  }

  @override
  FutureOr<bool> setDouble(String key, double val) {
    return sharedPreferences.setDouble('$prefix$key', val);
  }

  @override
  List<String> getStringList(String key) {
    return sharedPreferences.getStringList('$prefix$key');
  }

  @override
  FutureOr<bool> setStringList(String key, List<String> val) {
    return sharedPreferences.setStringList('$prefix$key', val);
  }

  @override
  dynamic get(String key) {
    return sharedPreferences.get('$prefix$key');
  }

  @override
  Set<String> getKeys() {
    return sharedPreferences.getKeys();
  }

  @override
  void clear() {
    if (prefix == '') {
      sharedPreferences.clear();
    } else {
      for (final key in sharedPreferences.getKeys()) {
        if (key.startsWith(prefix)) {
          sharedPreferences.remove('$prefix$key');
        }
      }
    }
  }
}

class JustCachePrefService extends BasePrefService {
  JustCachePrefService();

  Map<String, dynamic> cache;

  @override
  bool getBoolRaw(String key) {
    return cache[key];
  }

  @override
  FutureOr<bool> setBool(String key, bool val) {
    cache[key] = val;
    return true;
  }

  @override
  String getString(String key) {
    return cache[key];
  }

  @override
  FutureOr<bool> setString(String key, String val) {
    cache[key] = val;
    return true;
  }

  @override
  int getInt(String key) {
    return cache[key];
  }

  @override
  FutureOr<bool> setInt(String key, int val) {
    cache[key] = val;
    return true;
  }

  @override
  double getDouble(String key) {
    return cache[key];
  }

  @override
  FutureOr<bool> setDouble(String key, double val) {
    cache[key] = val;
    return true;
  }

  @override
  List<String> getStringList(String key) {
    return cache[key];
  }

  @override
  FutureOr<bool> setStringList(String key, List<String> val) {
    cache[key] = val;
    return true;
  }

  @override
  dynamic get(String key) {
    return cache[key];
  }

  @override
  Set<String> getKeys() {
    return Set<String>.from(cache.keys);
  }

  @override
  void clear() {
    cache.clear();
  }
}
