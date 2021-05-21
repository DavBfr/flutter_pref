// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'checkbox.dart';
import 'log.dart';
import 'service/pref_service.dart';

class PrefSwitch extends StatefulWidget {
  const PrefSwitch({
    this.title,
    required this.pref,
    Key? key,
    this.subtitle,
    this.ignoreTileTap = false,
    this.onChange,
    this.disabled = false,
    this.reversed = false,
    this.switchActiveColor,
  }) : super(key: key);

  final Widget? title;

  final Widget? subtitle;

  final String pref;

  final bool ignoreTileTap;

  final ValueChanged<bool>? onChange;

  final bool disabled;

  final Color? switchActiveColor;

  final bool reversed;

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
    PrefService.of(context, listen: false)
        .set(widget.pref, widget.reversed ? !value : value);

    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool? value;

    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e, s) {
      logger.severe('Unable to load the value', e, s);
    }

    if (widget.reversed && value != null) {
      value = !value;
    }

    if (value == null) {
      return PrefCheckbox(
        title: widget.title,
        pref: widget.pref,
        subtitle: widget.subtitle,
        ignoreTileTap: widget.ignoreTileTap,
        onChange: widget.onChange,
        disabled: widget.disabled,
        reversed: widget.reversed,
      );
    }

    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: Switch.adaptive(
        value: value,
        activeColor: widget.switchActiveColor,
        onChanged: widget.disabled ? null : (value) => _onChange(value),
      ),
      onTap: (widget.disabled || widget.ignoreTileTap)
          ? null
          : () => _onChange(!(value ?? true)),
    );
  }
}
