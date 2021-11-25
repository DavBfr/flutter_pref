// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'dialog.dart';
import 'service/pref_service.dart';

/// A button to open a preferences dialog
class PrefDialogButton extends StatelessWidget {
  /// Create a PrefDialogButton
  const PrefDialogButton({
    Key? key,
    this.title,
    required this.dialog,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onPop,
    this.barrierDismissible = true,
    this.onSubmit,
    this.onDismiss,
  }) : super(key: key);

  /// The button title
  final Widget? title;

  /// The button sub-title
  final Widget? subtitle;

  /// The dialog to open
  final PrefDialog dialog;

  /// A leading widget
  final Widget? leading;

  /// A trailing widget
  final Widget? trailing;

  /// Allow the dialog to be closed if clicked outside
  final bool barrierDismissible;

  /// Called when the dialog is closed
  final VoidCallback? onPop;

  /// Called when the dialog has been submitted
  final VoidCallback? onSubmit;

  /// Called when the dialog has been dismissed
  final VoidCallback? onDismiss;

  Future<void> _onTap(BuildContext context) async {
    onPop?.call();

    // Propagate the current inherited PrefService
    final service = PrefService.of(context);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => PrefService(
        service: service,
        child: dialog,
      ),
      barrierDismissible: barrierDismissible,
    );

    if (result ?? false) {
      onSubmit?.call();
    } else {
      onDismiss?.call();
    }
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
