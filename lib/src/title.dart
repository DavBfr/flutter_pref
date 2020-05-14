// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class PreferenceTitle extends StatelessWidget {
  const PreferenceTitle(
    this.title, {
    this.leftPadding = 10.0,
    this.style,
  });

  final String title;
  final double leftPadding;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: 0.0, top: 20.0),
      child: Text(
        title,
        style: style ??
            TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold),
      ),
    );
  }
}
