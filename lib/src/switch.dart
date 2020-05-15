// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'checkbox.dart';
import 'service/pref_service.dart';

class PrefSwitch extends StatefulWidget {
  const PrefSwitch({
    this.title,
    @required this.pref,
    Key key,
    this.subtitle,
    this.ignoreTileTap = false,
    this.onChange,
    this.disabled = false,
    this.switchActiveColor,
  })  : assert(pref != null),
        super(key: key);

  final Widget title;

  final Widget subtitle;

  final String pref;

  final bool ignoreTileTap;

  final ValueChanged<bool> onChange;

  final bool disabled;

  final Color switchActiveColor;

  @override
  _PrefSwitchState createState() => _PrefSwitchState();
}

class _PrefSwitchState extends State<PrefSwitch> {
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
    PrefService.of(context).setBool(widget.pref, value);

    if (widget.onChange != null) {
      widget.onChange(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final value = PrefService.of(context).getBool(widget.pref);

    if (value == null) {
      return PrefCheckbox(
        title: widget.title,
        pref: widget.pref,
        subtitle: widget.subtitle,
        ignoreTileTap: widget.ignoreTileTap,
        onChange: widget.onChange,
        disabled: widget.disabled,
      );
    }

    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: Switch.adaptive(
        value: value,
        activeColor: widget.switchActiveColor,
        onChanged: widget.disabled ? null : (val) => _onChange(value),
      ),
      onTap: (widget.disabled || widget.ignoreTileTap)
          ? null
          : () => _onChange(!(value ?? true)),
    );
  }
}
