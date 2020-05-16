// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class PrefHider extends StatefulWidget {
  const PrefHider({
    @required this.children,
    @required this.pref,
    this.reversed = false,
    this.nullValue = false,
  })  : assert(children != null),
        assert(pref != null),
        assert(reversed != null);

  final List<Widget> children;

  final String pref;

  final bool reversed;

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
    bool value;

    try {
      value = PrefService.of(context).getBool(widget.pref);
    } catch (e) {
      print('Unable to load the value: $e');
    }

    if ((value ?? widget.nullValue) != widget.reversed) {
      return Column(
        children: widget.children,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }

    return Container();
  }
}
