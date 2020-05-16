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
    this.reversed = false,
  })  : assert(pref != null),
        assert(reversed != null),
        super(key: key);

  final Widget title;

  final Widget subtitle;

  final String pref;

  final bool ignoreTileTap;

  final bool disabled;

  final bool reversed;

  final ValueChanged<bool> onChange;

  @override
  _PrefCheckboxState createState() => _PrefCheckboxState();
}

class _PrefCheckboxState extends State<PrefCheckbox> {
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

  Future<void> _onChange(bool value) async {
    setState(() {
      PrefService.of(context)
          .setBool(widget.pref, widget.reversed ? !value : value);
    });

    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool value;
    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e) {
      print('Unable to load the value: $e');
    }
    if (widget.reversed && value != null) {
      value = !value;
    }

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
