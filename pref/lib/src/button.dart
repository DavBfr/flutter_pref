// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class PrefButton extends StatelessWidget {
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
  }) : super(key: key);

  final Widget child;

  final Color? color;

  final Color? textColor;

  final Decoration? decoration;

  final Widget? leading;

  final Widget? title;

  final Widget? subtitle;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final button = FlatButton(
      child: child,
      color: color ?? theme.buttonTheme.colorScheme?.background,
      textColor: textColor,
      onPressed: onTap,
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
