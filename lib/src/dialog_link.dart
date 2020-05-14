// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'dialog.dart';

class PreferenceDialogLink extends StatelessWidget {
  const PreferenceDialogLink(this.title,
      {@required this.dialog,
      this.desc,
      this.leading,
      this.trailing,
      this.onPop,
      this.barrierDismissible = true});

  final String title;
  final String desc;
  final PreferenceDialog dialog;
  final Widget leading;
  final Widget trailing;
  final bool barrierDismissible;

  final Function onPop;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        await showDialog<void>(
            context: context,
            builder: (context) => dialog,
            barrierDismissible: barrierDismissible);
        if (onPop != null) {
          onPop();
        }
      },
      title: Text(title),
      subtitle: desc == null ? null : Text(desc),
      leading: leading,
      trailing: trailing,
    );
  }
}
