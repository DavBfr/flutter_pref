// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/base.dart';
import 'service/cache.dart';
import 'service/pref_service.dart';

class PrefPage extends StatelessWidget {
  const PrefPage({
    @required this.children,
    this.cache = false,
  }) : assert(children != null);

  final List<Widget> children;

  final bool cache;

  Future<BasePrefService> _createCache(BasePrefService parent) async {
    final service = PrefServiceCache();
    await service.apply(parent);
    return service;
  }

  @override
  Widget build(BuildContext context) {
    // Check if we already have a BasePrefService
    final _parent = PrefService.of(context);

    if (_parent == null) {
      throw FlutterError(
          'No PrefService widget found in the tree. Unable to load settings');
    }

    if (cache) {
      return FutureBuilder<BasePrefService>(
        future: _createCache(_parent),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          final _cache = snapshot.data;

          return PrefService(
            service: _cache,
            child: Builder(
              builder: (BuildContext context) => WillPopScope(
                onWillPop: () async {
                  // Save the settings
                  await _parent.apply(_cache);
                  return true;
                },
                child: ListView(children: children),
              ),
            ),
          );
        },
      );
    }

    return ListView(children: children);
  }
}
