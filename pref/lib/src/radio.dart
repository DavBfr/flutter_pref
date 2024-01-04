// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'disabler.dart';
import 'log.dart';
import 'service/pref_service.dart';

class PrefRadio<T> extends StatefulWidget {
  const PrefRadio({
    this.title,
    required this.value,
    required this.pref,
    super.key,
    this.subtitle,
    this.selected = false,
    this.ignoreTileTap = false,
    this.onSelect,
    this.disabled,
    this.leading,
    this.radioFirst = false,
  }) : assert(value != null);

  final Widget? title;

  final Widget? subtitle;

  final T value;

  final String pref;

  final bool selected;

  final Function? onSelect;

  final bool ignoreTileTap;

  final bool? disabled;

  final bool radioFirst;

  final Widget? leading;

  @override
  PrefRadioState createState() => PrefRadioState<T>();
}

class PrefRadioState<T> extends State<PrefRadio<T>> {
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

    if (widget.onSelect != null) {
      widget.onSelect!();
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

    if (widget.radioFirst) {
      return ListTile(
        enabled: !disabled,
        title: widget.title,
        trailing: widget.leading,
        subtitle: widget.subtitle,
        leading: Radio<T>(
          value: widget.value,
          groupValue: value,
          onChanged: disabled ? null : (T? val) => _onChange(widget.value),
        ),
        onTap: (widget.ignoreTileTap || disabled)
            ? null
            : () => _onChange(widget.value),
      );
    }

    return ListTile(
      enabled: !disabled,
      title: widget.title,
      leading: widget.leading,
      subtitle: widget.subtitle,
      trailing: Radio<T>(
        value: widget.value,
        groupValue: value,
        onChanged: disabled ? null : (T? val) => _onChange(widget.value),
      ),
      onTap: (widget.ignoreTileTap || disabled)
          ? null
          : () => _onChange(widget.value),
    );
  }
}
