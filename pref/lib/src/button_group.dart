// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'custom/button_group.dart';
import 'service/pref_service.dart';

class PrefButtonGroup<T> extends StatefulWidget {
  const PrefButtonGroup({
    Key? key,
    this.title,
    required this.items,
    required this.pref,
    this.subtitle,
    this.onChange,
    this.disabled = false,
  }) : super(key: key);

  final Widget? title;
  final Widget? subtitle;
  final String pref;

  final bool disabled;

  final ValueChanged<T>? onChange;

  final List<ButtonGroupItem<T>> items;

  @override
  _PrefButtonGroupState createState() => _PrefButtonGroupState<T>();
}

class _PrefButtonGroupState<T> extends State<PrefButtonGroup<T>> {
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

  void _onChange(T value) {
    PrefService.of(context, listen: false).set(widget.pref, value);
    if (mounted) {
      setState(() {});
    }
    
    if (widget.onChange != null) {
      widget.onChange!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    T? value;
    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e) {
      print('Unable to load the value: $e');
    }

    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: ButtonGroup<T>(
        items: widget.items,
        value: value,
        disabled: widget.disabled,
        onChanged: _onChange,
      ),
    );
  }
}
