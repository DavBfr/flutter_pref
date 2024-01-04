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
    super.key,
    required this.items,
    required this.pref,
    this.alignment = AlignmentDirectional.centerStart,
    this.autofocus = false,
    this.borderRadius,
    this.disabled,
    this.dropdownColor,
    this.elevation = 8,
    this.enableFeedback,
    this.focusColor,
    this.focusNode,
    this.fullWidth = true,
    this.icon,
    this.iconDisabledColor,
    this.iconEnabledColor,
    this.iconSize = 24.0,
    this.isDense = false,
    this.itemHeight = kMinInteractiveDimension,
    this.menuMaxHeight,
    this.onChange,
    this.style,
    this.subtitle,
    this.title,
    this.underline,
  });

  /// The title
  final Widget? title;

  /// The subtitle
  final Widget? subtitle;

  /// The preference key
  final String pref;

  /// The items to display
  final List<DropdownMenuItem<T>> items;

  /// Called when the value changes
  final ValueChanged<T?>? onChange;

  /// disable the widget interactions
  final bool? disabled;

  /// Use all the available width
  final bool fullWidth;

  /// The z-coordinate at which to place the menu when open.
  final int elevation;

  /// The text style to use for text in the dropdown button and the dropdown
  /// menu that appears when you tap the button.
  final TextStyle? style;

  /// The widget to use for drawing the drop-down button's underline.
  final Widget? underline;

  /// The widget to use for the drop-down button's icon.
  final Widget? icon;

  /// The color of any [Icon] descendant of [icon] if this button is disabled,
  final Color? iconDisabledColor;

  /// The color of any [Icon] descendant of [icon] if this button is enabled,
  final Color? iconEnabledColor;

  /// The size to use for the drop-down button's down arrow icon button.
  final double iconSize;

  /// Reduce the button's height.
  final bool isDense;

  /// If null, then the menu item heights will vary according to each menu item's
  /// intrinsic height.
  final double? itemHeight;

  /// The color for the button's [Material] when it has the input focus.
  final Color? focusColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// The background color of the dropdown.
  final Color? dropdownColor;

  /// The maximum height of the menu.
  final double? menuMaxHeight;

  /// Whether detected gestures should provide acoustic and/or haptic feedback.
  final bool? enableFeedback;

  /// Defines how the hint or the selected item is positioned within the button.
  final AlignmentGeometry alignment;

  /// Defines the corner radii of the menu's rounded rectangle shape.
  final BorderRadius? borderRadius;

  @override
  PrefDropdownState<T> createState() => PrefDropdownState<T>();
}

class PrefDropdownState<T> extends State<PrefDropdown<T>> {
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
      widget.onChange!(val);
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
              alignment: widget.alignment,
              autofocus: widget.autofocus,
              borderRadius: widget.borderRadius,
              dropdownColor: widget.dropdownColor,
              elevation: widget.elevation,
              enableFeedback: widget.enableFeedback,
              focusColor: widget.focusColor,
              focusNode: widget.focusNode,
              hint: widget.title,
              icon: widget.icon,
              iconDisabledColor: widget.iconDisabledColor,
              iconEnabledColor: widget.iconEnabledColor,
              iconSize: widget.iconSize,
              isDense: widget.isDense,
              isExpanded: true,
              itemHeight: widget.itemHeight,
              items: widget.items,
              menuMaxHeight: widget.menuMaxHeight,
              onChanged: disabled ? null : _onChange,
              style: widget.style,
              underline: widget.underline,
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
        alignment: widget.alignment,
        autofocus: widget.autofocus,
        borderRadius: widget.borderRadius,
        dropdownColor: widget.dropdownColor,
        elevation: widget.elevation,
        enableFeedback: widget.enableFeedback,
        focusColor: widget.focusColor,
        focusNode: widget.focusNode,
        icon: widget.icon,
        iconDisabledColor: widget.iconDisabledColor,
        iconEnabledColor: widget.iconEnabledColor,
        iconSize: widget.iconSize,
        isDense: widget.isDense,
        itemHeight: widget.itemHeight,
        items: widget.items,
        menuMaxHeight: widget.menuMaxHeight,
        onChanged: disabled ? null : _onChange,
        style: widget.style,
        underline: widget.underline,
        value: value,
      ),
    );
  }
}
