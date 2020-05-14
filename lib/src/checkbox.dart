// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class PrefCheckbox extends StatefulWidget {
  const PrefCheckbox({
    Key key,
    this.title,
    @required this.pref,
    this.subtitle,
    this.ignoreTileTap = false,
    this.onChange,
    this.disabled = false,
  })  : assert(pref != null),
        super(key: key);

  final Widget title;

  final Widget subtitle;

  final String pref;

  final bool ignoreTileTap;

  final bool disabled;

  final ValueChanged<bool> onChange;

  @override
  _PrefCheckboxState createState() => _PrefCheckboxState();
}

class _PrefCheckboxState extends State<PrefCheckbox> {
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

  Future<void> _onChange(bool value) async {
    setState(() {
      PrefService.of(context).setBool(widget.pref, value);
    });

    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = PrefService.of(context).getBool(widget.pref);
    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: Checkbox(
        value: value,
        tristate: value == null,
        onChanged: widget.disabled ? null : (val) => _onChange(val),
      ),
      onTap: (widget.ignoreTileTap || widget.disabled)
          ? null
          : () => _onChange(!(value ?? true)),
    );
  }
}
