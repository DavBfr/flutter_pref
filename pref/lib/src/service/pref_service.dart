// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:core';

import 'package:flutter/material.dart';

import 'base.dart';

class PrefService extends InheritedWidget {
  const PrefService({
    Key key,
    @required Widget child,
    @required this.service,
  })  : assert(service != null),
        super(key: key, child: child);

  final BasePrefService service;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static BasePrefService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PrefService>()?.service;
}
