// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'disabler.dart';
import 'log.dart';
import 'service/pref_service.dart';

/// Dropdown selection
class PrefDropdown<T> extends StatefulWidget {
  /// create a Dropdown selection
  const PrefDropdown({
    this.title,
    required this.pref,
    Key? key,
    this.subtitle,
    required this.items,
    this.onChange,
    this.disabled,
    this.fullWidth = true,
  }) : super(key: key);

  /// The title
  final Widget? title;

  /// The subtitle
  final Widget? subtitle;

  /// The preference key
  final String pref;

  /// The items to display
  final List<DropdownMenuItem<T>> items;

  /// Called when the value changes
  final ValueChanged<T>? onChange;

  /// disable the widget interactions
  final bool? disabled;

  /// Use all the available width
  final bool fullWidth;

  @override
  _PrefDropdownState<T> createState() => _PrefDropdownState<T>();
}

class _PrefDropdownState<T> extends State<PrefDropdown<T>> {
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

  void _onChange(T? val) {
    PrefService.of(context, listen: false).set(widget.pref, val);

    if (widget.onChange != null) {
      widget.onChange!(val!);
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

    // check if the value is present in the list of choices
    var found = false;
    for (final item in widget.items) {
      if (item.value == value) {
        found = true;
      }
    }
    if (!found) {
      value = null;
    }

    final disabled =
        widget.disabled ?? PrefDisableState.of(context)?.disabled ?? false;

    if (widget.fullWidth) {
      return ListTile(
        enabled: !disabled,
        title: value == null
            ? null
            : DefaultTextStyle.merge(
                style: const TextStyle(fontSize: 12),
                child: widget.title!,
              ),
        isThreeLine: widget.subtitle != null,
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<T>(
              hint: widget.title,
              isExpanded: true,
              items: widget.items,
              onChanged: disabled ? null : _onChange,
              value: value,
            ),
            if (widget.subtitle != null) widget.subtitle!
          ],
        ),
      );
    }

    return ListTile(
      enabled: !disabled,
      title: widget.title,
      subtitle: widget.subtitle,
      trailing: DropdownButton<T>(
        items: widget.items,
        onChanged: disabled ? null : _onChange,
        value: value,
      ),
    );
  }
}
