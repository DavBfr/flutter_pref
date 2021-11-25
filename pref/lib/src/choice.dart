// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import '../pref.dart';
import 'dialog.dart';
import 'dialog_button.dart';
import 'log.dart';
import 'radio.dart';
import 'service/pref_service.dart';

/// Display a Dialog with a list of items to choose
class PrefChoice<T> extends StatefulWidget {
  /// Create a PrefChoice Widget
  const PrefChoice({
    Key? key,
    this.title,
    required this.pref,
    this.subtitle,
    required this.items,
    this.onChange,
    this.disabled,
    this.cancel,
    this.submit,
    this.radioFirst = true,
  }) : super(key: key);

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
  _PrefChoiceState<T> createState() => _PrefChoiceState<T>();
}

class _PrefChoiceState<T> extends State<PrefChoice<T>> {
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
              ),
            )
            .toList(),
      ),
    );
  }
}
