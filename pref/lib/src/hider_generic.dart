// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'log.dart';
import 'service/pref_service.dart';

/// A widget that hides its preference children depending on a preference value
class PrefHiderGeneric<T> extends StatefulWidget {
  /// create a Hider widget
  const PrefHiderGeneric({
    Key? key,
    required this.children,
    required this.pref,
    required this.nullValue,
    this.reversed = false,
  }) : super(key: key);

  /// The widgets to hide
  final List<Widget> children;

  /// The preference key
  final String pref;

  /// reverse the behavior
  final bool reversed;

  /// the fallback value if the pref value is null
  final T? nullValue;

  @override
  PrefHiderGenericState<T> createState() => PrefHiderGenericState<T>();
}

class PrefHiderGenericState<T> extends State<PrefHiderGeneric<T>> {
  @override
  void didChangeDependencies() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    PrefService.of(context).removeKeyListener(widget.pref, _onNotify);
    super.deactivate();
  }

  @override
  void reassemble() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.reassemble();
  }

  void _onNotify() {
    setState(() {});
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    final dynamic value = PrefService.of(context).get<dynamic>(widget.pref);
    properties.add(DiagnosticsProperty(
      'pref',
      value,
      description: '${widget.pref} = $value',
    ));
  }

  @override
  Widget build(BuildContext context) {
    T? value;

    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e, s) {
      logger.severe('Unable to load the value', e, s);
    }

    if ((value == widget.nullValue) == widget.reversed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.children,
      );
    }
    return Container();
  }
}
