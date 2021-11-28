// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'disabler.dart';
import 'log.dart';
import 'service/pref_service.dart';

/// Display a boolean value
class PrefCheckbox extends StatefulWidget {
  /// Create a PrefCheckbox Widget
  const PrefCheckbox({
    Key? key,
    this.title,
    required this.pref,
    this.subtitle,
    this.ignoreTileTap = false,
    this.onChange,
    this.disabled,
    this.reversed = false,
  }) : super(key: key);

  /// Checkbox title
  final Widget? title;

  /// Checkbox sub-title
  final Widget? subtitle;

  /// Preference key to display
  final String pref;

  /// Ignore taps on the text
  final bool ignoreTileTap;

  /// Disable user interactions
  final bool? disabled;

  /// Reverse the checked status (!pref)
  final bool reversed;

  /// Called when the value is changed
  final ValueChanged<bool>? onChange;

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
    PrefService.of(context, listen: false)
        .set(widget.pref, widget.reversed ? !value : value);

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
    bool? value;
    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e, s) {
      logger.severe('Unable to load the value', e, s);
    }
    if (widget.reversed && value != null) {
      value = !value;
    }

    final disabled =
        widget.disabled ?? PrefDisableState.of(context)?.disabled ?? false;

    return ListTile(
      enabled: !disabled,
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: Checkbox(
        value: value,
        tristate: value == null,
        onChanged: disabled ? null : (val) => _onChange(val!),
      ),
      onTap: (widget.ignoreTileTap || disabled)
          ? null
          : () => _onChange(!(value ?? true)),
    );
  }
}
