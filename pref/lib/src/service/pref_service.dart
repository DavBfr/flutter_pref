// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'base.dart';

class PrefService extends InheritedNotifier {
  const PrefService({
    Key? key,
    required Widget child,
    required this.service,
  }) : super(key: key, child: child, notifier: service);

  final BasePrefService service;

  @override
  bool updateShouldNotify(PrefService oldWidget) =>
      service != oldWidget.service;

  static BasePrefService of(BuildContext context, {bool listen = true}) {
    if (listen) {
      return context.dependOnInheritedWidgetOfExactType<PrefService>()!.service;
    }

    return context.findAncestorWidgetOfExactType<PrefService>()!.service;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('service', service));
    service.debugFillProperties(properties);
  }
}
