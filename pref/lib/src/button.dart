// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Button
class PrefButton extends StatelessWidget {
  /// Create a PrefButton Widget
  const PrefButton({
    Key? key,
    required this.child,
    this.color,
    this.textColor,
    this.decoration,
    this.leading,
    this.title,
    this.subtitle,
    this.onTap,
  })  : assert(title != child,
            'Use a title to define your own button or child for the button content'),
        super(key: key);

  /// Widget to display inside the button
  final Widget child;

  /// Button color
  final Color? color;

  /// Text color
  final Color? textColor;

  /// Button decoration
  final Decoration? decoration;

  /// Leading Widget
  final Widget? leading;

  /// Text Widget
  final Widget? title;

  /// Button sub-title
  final Widget? subtitle;

  /// Called wien the button is activated
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = MaterialButton(
      color: color ?? theme.buttonTheme.colorScheme?.background,
      textColor: textColor,
      onPressed: onTap,
      child: child,
    );

    return Container(
      decoration: decoration,
      child: ListTile(
        leading: leading,
        title: title ?? button,
        trailing: title == null ? null : button,
        subtitle: subtitle,
      ),
    );
  }
}
