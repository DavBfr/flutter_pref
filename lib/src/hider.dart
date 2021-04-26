// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

/// A widget that hides its children depending on a preference value
class PrefHider extends StatefulWidget {
  /// create a Hider widget
  const PrefHider({
    required this.children,
    required this.pref,
    this.reversed = false,
    this.nullValue = false,
  });

  /// The widgets to hide
  final List<Widget> children;

  /// The preference key
  final String pref;

  /// reverse the behavour
  final bool reversed;

  /// the fallback value if the pref value is null
  final bool nullValue;

  @override
  _PrefHiderState createState() => _PrefHiderState();
}

class _PrefHiderState extends State<PrefHider> {
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
  Widget build(BuildContext context) {
    bool? value;

    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e) {
      print('Unable to load the value: $e');
    }

    if ((value ?? widget.nullValue) != widget.reversed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widget.children,
      );
    }

    return Container();
  }
}
