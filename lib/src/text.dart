// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class PreferenceText extends StatelessWidget {
  const PreferenceText(
    this.text, {
    this.style,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
  });

  final String text;

  final TextStyle style;
  final Decoration decoration;

  final Widget leading;
  final Text subtitle;

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ListTile(
        leading: leading,
        onTap: onTap,
        title: Text(
          text,
          style: style,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle,
      ),
    );
  }
}
