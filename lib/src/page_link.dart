// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'page.dart';

class PreferencePageLink extends StatelessWidget {
  const PreferencePageLink(this.title,
      {@required this.page,
      this.desc,
      this.pageTitle,
      this.leading,
      this.trailing});

  final String title;
  final String pageTitle;
  final String desc;
  final PreferencePage page;
  final Widget leading;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).push<void>(
        MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(pageTitle ?? title),
            ),
            body: page,
          ),
        ),
      ),
      title: Text(title),
      subtitle: desc == null ? null : Text(desc),
      leading: leading,
      trailing: trailing,
    );
  }
}
