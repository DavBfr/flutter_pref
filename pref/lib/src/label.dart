// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class PrefLabel extends StatelessWidget {
  const PrefLabel({
    required this.title,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
    this.margin,
    this.padding,
  });

  final Widget title;

  final Decoration? decoration;

  final Widget? leading;
  final Widget? subtitle;

  final Function? onTap;

  final EdgeInsetsGeometry? padding;
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
