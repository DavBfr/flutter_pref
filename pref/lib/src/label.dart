// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'disabler.dart';

/// A label
class PrefLabel extends StatelessWidget {
  /// Create a label
  const PrefLabel({
    super.key,
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

  /// called when the user clicks the label
  final VoidCallback? onTap;

  /// padding
  final EdgeInsetsGeometry? padding;

  /// margin
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final disabled = PrefDisableState.of(context)?.disabled ?? false;

    return Container(
      margin: margin,
      padding: padding,
      decoration: decoration,
      child: ListTile(
        enabled: !disabled,
        leading: leading,
        onTap: onTap,
        title: DefaultTextStyle.merge(
          overflow: TextOverflow.ellipsis,
          child: title,
        ),
        subtitle: subtitle,
      ),
    );
  }
}
