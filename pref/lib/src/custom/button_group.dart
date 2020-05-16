// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ButtonGroup<T> extends StatelessWidget {
  const ButtonGroup({
    Key key,
    this.value,
    @required this.onChanged,
    this.disabled = false,
    this.items,
  })  : assert(onChanged != null),
        assert(disabled != null),
        super(key: key);

  final ValueChanged<T> onChanged;
  final bool disabled;
  final T value;
  final List<ButtonGroupItem<T>> items;

  static const _startShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(10),
      bottomLeft: Radius.circular(10),
    ),
  );

  static const _middleShape = RoundedRectangleBorder();

  static const _endShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(10),
      bottomRight: Radius.circular(10),
    ),
  );

  Color _getTextColor(
    ThemeData theme,
    ButtonThemeData buttonTheme,
    Color fillColor,
  ) {
    final themeIsDark = theme.brightness == Brightness.dark;
    final fillIsDark = fillColor != null
        ? ThemeData.estimateBrightnessForColor(fillColor) == Brightness.dark
        : themeIsDark;

    switch (buttonTheme.textTheme) {
      case ButtonTextTheme.normal:
        return disabled
            ? theme.disabledColor
            : (themeIsDark ? Colors.white : Colors.black87);
      case ButtonTextTheme.accent:
        return disabled ? theme.disabledColor : theme.accentColor;
      case ButtonTextTheme.primary:
        return disabled
            ? (themeIsDark ? Colors.white30 : Colors.black38)
            : (fillIsDark ? Colors.white : Colors.black);
    }
    return null;
  }

  Widget _button(
    BuildContext context,
    VoidCallback onPressed,
    bool selected,
    Widget child,
    ShapeBorder shape,
  ) {
    final theme = Theme.of(context);
    final buttonTheme = ButtonTheme.of(context);
    final fillColor = selected ? theme.accentColor : theme.buttonColor;
    final textColor = _getTextColor(theme, buttonTheme, fillColor);

    return RawMaterialButton(
      onPressed: onPressed,
      fillColor: fillColor,
      textStyle: theme.textTheme.button.copyWith(color: textColor),
      highlightColor: theme.highlightColor,
      splashColor: theme.splashColor,
      elevation: 0,
      shape: shape,
      highlightElevation: 0,
      disabledElevation: 0,
      padding: const EdgeInsets.all(1),
      constraints: const BoxConstraints(
        minWidth: 60,
        minHeight: 40,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttons = <Widget>[];

    for (final item in items) {
      buttons.add(
        _button(
          context,
          disabled ? null : () => onChanged(item.value),
          value == item.value,
          item.child,
          item == items.first
              ? _startShape
              : (item == items.last ? _endShape : _middleShape),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: buttons,
    );
  }
}

class ButtonGroupItem<T> {
  const ButtonGroupItem({this.value, this.child});

  final T value;
  final Widget child;

  @override
  String toString() => '$runtimeType $value => $child';
}
