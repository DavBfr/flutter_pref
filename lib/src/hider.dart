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
  })  : assert(children != null),
        assert(pref != null);

  final List<Widget> children;

  final String pref;

  @override
  _PrefHiderState createState() => _PrefHiderState();
}

class _PrefHiderState extends State<PrefHider> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PrefService.of(context).onNotify(widget.pref, _onNotify);
  }

  @override
  void deactivate() {
    super.deactivate();
    PrefService.of(context).onNotifyRemove(widget.pref, _onNotify);
  }

  void _onNotify() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (PrefService.of(context).getBool(widget.pref) == true) {
      return Container();
    }

    return Column(
      children: widget.children,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
