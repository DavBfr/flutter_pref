// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'page.dart';

class PrefPageButton extends StatelessWidget {
  const PrefPageButton({
    this.title,
    @required this.page,
    this.subtitle,
    this.pageTitle,
    this.leading,
    this.trailing,
  });

  final Widget title;
  final Widget pageTitle;
  final Widget subtitle;
  final PrefPage page;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: pageTitle ?? title,
            ),
            body: page,
          ),
        ),
      ),
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
    );
  }
}
