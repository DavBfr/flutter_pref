// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'service/base.dart';
import 'service/cache.dart';
import 'service/pref_service.dart';

class PrefDialog extends StatefulWidget {
  const PrefDialog({
    @required this.children,
    this.title,
    this.submit,
    bool onlySaveOnSubmit,
    this.cancel,
  })  : assert(children != null),
        onlySaveOnSubmit = onlySaveOnSubmit ?? submit != null;

  final Widget title;
  final List<Widget> children;
  final Widget submit;
  final Widget cancel;

  final bool onlySaveOnSubmit;

  @override
  PrefDialogState createState() => PrefDialogState();
}

class PrefDialogState extends State<PrefDialog> {
  Future<BasePrefService> _cache;

  @override
  void didChangeDependencies() {
    if (widget.onlySaveOnSubmit) {
      _cache ??= _createCache();
    }
    super.didChangeDependencies();
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

  Widget _buildDialog(BuildContext context, BasePrefService parent) {
    final actions = <Widget>[];

    if (widget.cancel != null && widget.onlySaveOnSubmit) {
      actions.add(
        FlatButton(
          child: widget.cancel,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }

    if (widget.submit != null) {
      actions.add(
        FlatButton(
          child: widget.submit,
          onPressed: () {
            if (widget.onlySaveOnSubmit) {
              parent.apply(PrefService.of(context));
            }
            Navigator.of(context).pop();
          },
        ),
      );
    }

    return AlertDialog(
      title: widget.title,
      content: SingleChildScrollView(
        child: Column(
          children: widget.children,
        ),
      ),
      actions: actions,
    );
  }

  Future<BasePrefService> _createCache() async {
    final service = PrefServiceCache();
    await service.apply(_parent);
    return service;
  }

  Widget _buildService(BuildContext context, BasePrefService parent) {
    if (widget.onlySaveOnSubmit) {
      return FutureBuilder(
        future: _cache,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          return PrefService(
            service: snapshot.data,
            child: Builder(
              builder: (BuildContext context) => _buildDialog(context, parent),
            ),
          );
        },
      );
    }

    return _buildDialog(context, parent);
  }

  @override
  Widget build(BuildContext context) {
    // Check if we already have a BasePrefService
    final service = PrefService.of(context);
    if (service == null) {
      throw FlutterError(
          'No PrefService widget found in the tree. Unable to load settings');
    }

    return _buildService(context, service);
  }
}
