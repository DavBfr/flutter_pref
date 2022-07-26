// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'custom/button_group.dart';
import 'disabler.dart';
import 'log.dart';
import 'service/pref_service.dart';

class PrefButtonGroup<T> extends StatefulWidget {
  const PrefButtonGroup({
    Key? key,
    this.title,
    required this.items,
    required this.pref,
    this.subtitle,
    this.onChange,
    this.disabled,
  }) : super(key: key);

  final Widget? title;
  final Widget? subtitle;
  final String pref;

  final bool? disabled;

  final ValueChanged<T>? onChange;

  final List<ButtonGroupItem<T>> items;

  @override
  PrefButtonGroupState createState() => PrefButtonGroupState<T>();
}

class PrefButtonGroupState<T> extends State<PrefButtonGroup<T>> {
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

    final disabled =
        widget.disabled ?? PrefDisableState.of(context)?.disabled ?? false;

    return ListTile(
      enabled: !disabled,
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: ButtonGroup<T>(
        items: widget.items,
        value: value,
        disabled: disabled,
        onChanged: _onChange,
      ),
    );
  }
}
