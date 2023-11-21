// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service_cache.dart';

class PrefPage extends PrefCache {
  const PrefPage({
    Key? key,
    required this.children,
    bool cache = false,
  }) : super(key: key, cache: cache);

  final List<Widget> children;

  @override
  PrefPageState createState() => PrefPageState();
}

class PrefPageState extends PrefCacheState<PrefPage> {
  @override
  Widget buildChild(BuildContext context) {
    if (widget.cache) {
      // Flutter 3.12
      // return PopScope(
      //   onPopInvoked: (bool didPop) async {
      //     // Save the settings
      //     await apply();
      //   },
      //   child: ListView(children: widget.children),
      // );
      return WillPopScope(
        onWillPop: () async {
          // Save the settings
          await apply();
          return true;
        },
        child: ListView(children: widget.children),
      );
    }

    return ListView(children: widget.children);
  }
}
