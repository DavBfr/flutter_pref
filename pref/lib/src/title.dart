// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class PrefTitle extends StatelessWidget {
  const PrefTitle({
    @required this.title,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
    this.margin,
    this.padding,
  }) : assert(title != null);

  final Widget title;

  final Decoration decoration;

  final Widget leading;
  final Widget subtitle;

  final Function onTap;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.headline5.apply(color: theme.accentColor);

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.only(left: 10, bottom: 0, top: 20),
      decoration: decoration,
      child: ListTile(
        leading: leading,
        onTap: onTap,
        title: DefaultTextStyle.merge(
          overflow: TextOverflow.ellipsis,
          style: style,
          child: title,
        ),
        subtitle: subtitle,
      ),
    );
  }
}
