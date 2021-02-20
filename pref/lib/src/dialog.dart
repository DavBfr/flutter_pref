// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';
import 'service_cache.dart';

class PrefDialog extends PrefCache {
  const PrefDialog({
    Key? key,
    required this.children,
    this.title,
    this.submit,
    bool? onlySaveOnSubmit,
    this.dismissOnChange = false,
    this.cancel,
  }) : super(key: key, cache: onlySaveOnSubmit ?? submit != null);

  final Widget? title;
  final List<Widget> children;
  final Widget? submit;
  final Widget? cancel;

  final bool dismissOnChange;

  @override
  PrefDialogState createState() => PrefDialogState();
}

class PrefDialogState extends PrefCacheState<PrefDialog> {
  @override
  Widget buildChild(BuildContext context) {
    final actions = <Widget>[];

    if (widget.cancel != null && widget.cache) {
      actions.add(
        TextButton(
          child: widget.cancel!,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }

    if (widget.submit != null) {
      actions.add(
        TextButton(
          child: widget.submit!,
          onPressed: () async {
            await apply();
            Navigator.of(context).pop();
          },
        ),
      );
    }

    if (widget.dismissOnChange) {
      late Function f;

      f = () async {
        PrefService.of(context).removeListener(f as void Function());
        await apply();
        Navigator.of(context).pop();
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
