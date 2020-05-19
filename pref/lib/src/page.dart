// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class PrefPage extends StatefulWidget {
  const PrefPage({
    @required this.children,
  }) : assert(children != null);

  final List<Widget> children;

  @override
  _PrefPageState createState() => _PrefPageState();
}

class _PrefPageState extends State<PrefPage> {
  @override
  Widget build(BuildContext context) {
    // Check if we already have a BasePrefService
    final service = PrefService.of(context);

    if (service == null) {
      throw FlutterError(
          'No PrefService widget found in the tree. Unable to load settings');
    }

    return ListView(children: widget.children);
  }
}
