// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';
import 'service_cache.dart';

/// Dialog to display sub-preference items
class PrefDialog extends PrefCache {
  /// Create a Preference Dialog
  const PrefDialog({
    Key? key,
    required this.children,
    this.title,
    this.submit,
    bool? onlySaveOnSubmit,
    this.dismissOnChange = false,
    this.cancel,
  }) : super(key: key, cache: onlySaveOnSubmit ?? submit != null);

  /// The Dialog title
  final Widget? title;

  /// The elements to display in the dialog
  final List<Widget> children;

  /// The submit button
  final Widget? submit;

  /// The cancel button
  final Widget? cancel;

  /// Automatically close the dialog if the preferences are updated
  final bool dismissOnChange;

  @override
  PrefDialogState createState() => PrefDialogState();
}

/// The Preference Dialog State
class PrefDialogState extends PrefCacheState<PrefDialog> {
  @override
  Widget buildChild(BuildContext context) {
    final actions = <Widget>[];

    if (widget.cancel != null && widget.cache) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: widget.cancel!,
        ),
      );
    }

    if (widget.submit != null) {
      actions.add(
        TextButton(
          onPressed: () async {
            await apply();
            Navigator.of(context).pop(true);
          },
          child: widget.submit!,
        ),
      );
    }

    if (widget.dismissOnChange) {
      late Function f;

      f = () async {
        PrefService.of(context).removeListener(f as void Function());
        await apply();
        Navigator.of(context).pop(true);
      };

      PrefService.of(context).addListener(f as void Function());
    }

    return AlertDialog(
      title: widget.title,
      content: SingleChildScrollView(
        child: Column(
          children: widget.children,
        ),
      ),
      actions: actions,
    );
  }
}
