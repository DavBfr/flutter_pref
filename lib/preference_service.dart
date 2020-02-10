import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';

import 'preference_service_base.dart';
import 'preference_service_shared.dart';

class PrefService extends InheritedWidget {
  const PrefService({
    Key key,
    @required Widget child,
    @required this.service,
  })  : assert(service != null),
        super(key: key, child: child);

  final BasePrefService service;

  static BasePrefService _instance;

  @deprecated
  final Map cache = const {};

  @deprecated
  final String prefix = '';

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
