// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service_cache.dart';

class PrefPage extends PrefCache {
  const PrefPage({
    super.key,
    required this.children,
    super.cache = false,
    this.scrollable = true,
  });

  final List<Widget> children;

  // Enables ListView if enabled, a Column is used otherwise.
  final bool scrollable;

  @override
  PrefPageState createState() => PrefPageState();
}

class PrefPageState extends PrefCacheState<PrefPage> {
  @override
  Widget buildChild(BuildContext context) {
    final child = widget.scrollable
        ? ListView(children: widget.children)
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.children,
          );

    if (widget.cache) {
      return PopScope(
        onPopInvoked: (bool didPop) async {
          // Save the settings
          await apply();
        },
        child: child,
      );
    }

    return child;
  }
}
