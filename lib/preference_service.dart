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
  static void checkInit() {
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
      subs[key] = Set<VoidCallback>();
    }
    subs[key].add(f);
  }

  void onNotifyRemove(String key, VoidCallback f) {
    subs[key]?.remove(f);
  }

  void setDefaultValues(Map<String, dynamic> values) {
    final keys = getKeys();
    for (final key in values.keys) {
      if (keys.contains(key)) {
        continue;
      }

      final val = values[key];
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
      final val = getBoolRaw(key.substring(1));
      if (val == null) return null;
      return !val;
    }

    return getBoolRaw(key);
  }

  Future<void> apply(BasePrefService other) async {
    for (final key in other.getKeys()) {
      await set(key, other.get(key));
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

  @override
  String toString() => toMap().toString();

  @protected
  bool getBoolRaw(String key);

  @mustCallSuper
  FutureOr<bool> setBool(String key, bool val) {
    notifyListeners();
    return true;
  }

  String getString(String key);

  @mustCallSuper
  FutureOr<bool> setString(String key, String val) {
    notifyListeners();
    return true;
  }

  int getInt(String key);

  @mustCallSuper
  FutureOr<bool> setInt(String key, int val) {
    notifyListeners();
    return true;
  }

  double getDouble(String key);

  @mustCallSuper
  FutureOr<bool> setDouble(String key, double val) {
    notifyListeners();
    return true;
  }

  List<String> getStringList(String key);

  @mustCallSuper
  FutureOr<bool> setStringList(String key, List<String> val) {
    notifyListeners();
    return true;
  }

  dynamic get(String key);

  Set<String> getKeys();

  @mustCallSuper
  void clear() {
    notifyListeners();
  }
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

    super.clear();
  }
}

class JustCachePrefService extends BasePrefService {
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
    print('_cache[$key] => ${_cache[key]}');
    return _cache[key];
  }

  @override
  Set<String> getKeys() {
    return Set<String>.from(_cache.keys);
  }

  @override
  void clear() {
    _cache.clear();
    super.clear();
  }
}
