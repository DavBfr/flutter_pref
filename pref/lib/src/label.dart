// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// A label
class PrefLabel extends StatelessWidget {
  /// Create a label
  const PrefLabel({
    required this.title,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
    this.margin,
    this.padding,
  });

  /// the label's title
  final Widget title;

  /// optional decoration
  final Decoration? decoration;

  /// leading widget
  final Widget? leading;

  /// subtitle widget
  final Widget? subtitle;

  /// called when the user actionate the label
  final Function? onTap;

  /// padding
  final EdgeInsetsGeometry? padding;

  /// margin
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: ListTile(
        leading: leading,
        onTap: onTap as void Function()?,
        title: DefaultTextStyle.merge(
          overflow: TextOverflow.ellipsis,
          child: title,
        ),
        subtitle: subtitle,
      ),
    );
  }
}
