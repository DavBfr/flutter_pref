// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pref.dart';
import 'log.dart';

/// Display a Dialog with a list of items to choose
class PrefChoice<T> extends StatefulWidget {
  /// Create a PrefChoice Widget
  const PrefChoice({
    super.key,
    this.title,
    required this.pref,
    this.subtitle,
    required this.items,
    this.onChange,
    this.disabled,
    this.cancel,
    this.submit,
    this.radioFirst = true,
  });

  /// Button title
  final Widget? title;

  /// Button sub-title
  final Widget? subtitle;

  /// Preference key to update
  final String pref;

  /// List of items to choose from
  final List<DropdownMenuItem<T>> items;

  /// Called when the user selects something
  final ValueChanged<T>? onChange;

  /// Disable user interactions
  final bool? disabled;

  /// Submit button
  final Widget? submit;

  /// Cancel button
  final Widget? cancel;

  /// Display the radio buttons on the left
  final bool radioFirst;

  @override
  PrefChoiceState<T> createState() => PrefChoiceState<T>();
}

class PrefChoiceState<T> extends State<PrefChoice<T>> {
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

  Future<void> _onChange(dynamic value) async {
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
      value = PrefService.of(context).get(widget.pref);
    } catch (e, s) {
      logger.severe('Unable to load the value', e, s);
    }

    // check if the value is present in the list of choices
    Widget? selected;
    for (final item in widget.items) {
      if (item.value == value) {
        selected = item.child;
      }
    }

    if (selected == null) {
      value = null;
    }

    final disabled =
        widget.disabled ?? PrefDisableState.of(context)?.disabled ?? false;

    return PrefDialogButton(
      disabled: disabled,
      title: widget.title,
      subtitle: widget.subtitle ?? selected,
      dialog: PrefDialog(
        title: widget.title,
        onlySaveOnSubmit: true,
        dismissOnChange: widget.submit == null,
        cancel: widget.cancel,
        submit: widget.submit,
        children: widget.items
            .map<PrefRadio<T?>>(
              (e) => PrefRadio<T?>(
                title: e.child,
                value: e.value,
                pref: widget.pref,
                radioFirst: widget.radioFirst,
                onSelect: () => {
                  if (widget.submit == null) {_onChange(e.value)}
                },
              ),
            )
            .toList(),
        onSubmit: () {
          if (widget.submit != null) {
            T? submittedValue;
            try {
              submittedValue = PrefService.of(context).get(widget.pref);
            } catch (e, s) {
              logger.severe('Unable to load the value', e, s);
            }
            _onChange(submittedValue);
          }
        },
      ),
    );
  }
}
