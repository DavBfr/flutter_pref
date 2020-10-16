// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'service/base.dart';
import 'service/cache.dart';
import 'service/pref_service.dart';

abstract class PrefCache extends StatefulWidget {
  const PrefCache({
    Key key,
    @required this.cache,
  })  : assert(cache != null),
        super(key: key);

  final bool cache;
}

abstract class PrefCacheState<T extends PrefCache> extends State<T> {
  BasePrefService _cache;
  BasePrefService _parent;
  BasePrefService get service => widget.cache ? _cache : _parent;

  @override
  void didChangeDependencies() {
    _parent = PrefService.of(context, listen: false);

    // Check if we already have a BasePrefService
    if (_parent == null) {
      throw FlutterError(
          'No PrefService widget found in the tree. Unable to load settings');
    }

    if (widget.cache && _cache == null) {
      _createCache();
    }
    super.didChangeDependencies();
  }

  Future<void> _createCache() async {
    final service = PrefServiceCache();
    await service.apply(_parent);
    setState(() {
      _cache = service;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.cache) {
      return buildChild(context);
    }

    if (_cache == null) {
      return const SizedBox();
    }

    return PrefService(
      service: _cache,
      child: Builder(
        builder: (BuildContext context) => buildChild(context),
      ),
    );
  }

  Future<void> apply() async {
    if (!widget.cache) {
      return;
    }

    await _parent.apply(_cache);
  }

  Widget buildChild(BuildContext context);
}
