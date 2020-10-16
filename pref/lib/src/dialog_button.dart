// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'dialog.dart';
import 'service/pref_service.dart';

class PrefDialogButton extends StatelessWidget {
  const PrefDialogButton({
    this.title,
    @required this.dialog,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPop,
    this.barrierDismissible = true,
  });

  final Widget title;

  final Widget subtitle;

  final PrefDialog dialog;

  final Widget leading;

  final Widget trailing;

  final bool barrierDismissible;

  final VoidCallback onPop;

  Future<void> _onTap(BuildContext context) async {
    if (onPop != null) {
      onPop();
    }

    // Propagate the current inherited PrefService
    final service = PrefService.of(context);

    await showDialog<bool>(
      context: context,
      builder: (context) => PrefService(
        service: service,
        child: dialog,
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _onTap(context),
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
    );
  }
}
