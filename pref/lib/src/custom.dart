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

/// Display a custom value
class PrefCustom<T> extends StatefulWidget {
  /// Create a PrefCustom Widget
  const PrefCustom({
    Key? key,
    this.title,
    required this.pref,
    this.subtitle,
    this.onChange,
    this.disabled,
    required this.onTap,
    this.builder,
  }) : super(key: key);

  /// Checkbox title
  final Widget? title;

  /// Checkbox sub-title
  final Widget? subtitle;

  /// Preference key to display
  final String pref;

  /// Disable user interactions
  final bool? disabled;

  /// Called when the value is changed
  final ValueChanged<T?>? onChange;

  /// Callback that returns the new value
  final FutureOr<T?> Function(BuildContext context, T? value) onTap;

  /// Build the current value
  final Widget Function(BuildContext context, T? value)? builder;

  @override
  _PrefCustomState<T> createState() => _PrefCustomState<T>();
}

class _PrefCustomState<T> extends State<PrefCustom<T>> {
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

  Future<void> _onChange(T? value) async {
    PrefService.of(context, listen: false).set(widget.pref, value);
    widget.onChange?.call(value);
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
      value = PrefService.of(context).get<T>(widget.pref);
    } catch (e, s) {
      logger.severe('Unable to load the value', e, s);
    }

    final disabled =
        widget.disabled ?? PrefDisableState.of(context)?.disabled ?? false;

    final child =
        widget.builder?.call(context, value) ?? Text(value.toString());

    return ListTile(
      enabled: !disabled,
      title: widget.title ?? child,
      subtitle: widget.subtitle,
      trailing: widget.title == null ? null : child,
      onTap: disabled ? null : () => _tap(value),
    );
  }

  Future<void> _tap(T? value) async {
    final result = await widget.onTap(context, value);
    if (value != result) {
      await _onChange(result);
    }
  }
}
