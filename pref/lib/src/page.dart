// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/base.dart';
import 'service/cache.dart';
import 'service/pref_service.dart';

class PrefPage extends StatefulWidget {
  const PrefPage({
    @required this.children,
    this.cache = false,
  })  : assert(children != null),
        assert(cache != null);

  final List<Widget> children;

  final bool cache;

  @override
  _PrefPageState createState() => _PrefPageState();
}

class _PrefPageState extends State<PrefPage> {
  Future<BasePrefService> _cache;

  @override
  void didChangeDependencies() {
    if (widget.cache) {
      _cache ??= _createCache();
    }
    super.didChangeDependencies();
  }

  Future<BasePrefService> _createCache() async {
    final service = PrefServiceCache();
    await service.apply(_parent);
    return service;
  }

  BasePrefService get _parent {
    final parent = PrefService.of(context);

    // Check if we already have a BasePrefService
    if (parent == null) {
      throw FlutterError(
          'No PrefService widget found in the tree. Unable to load settings');
    }

    return parent;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cache) {
      return FutureBuilder<BasePrefService>(
        future: _cache,
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
                child: ListView(children: widget.children),
              ),
            ),
          );
        },
      );
    }

    return ListView(children: widget.children);
  }
}
