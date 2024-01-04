// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'disabler.dart';

/// LiltTile Button with a chevron
class PrefChevron extends StatelessWidget {
  /// Create a PrefButton Widget
  const PrefChevron({
    super.key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  /// Leading Widget
  final Widget? leading;

  /// Text Widget
  final Widget? title;

  /// Button sub-title
  final Widget? subtitle;

  final Widget? trailing;

  /// Called when the button is activated
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled =
        onTap == null || (PrefDisableState.of(context)?.disabled ?? false);

    return ListTile(
      enabled: !disabled,
      leading: leading,
      title: title,
      trailing: trailing ??
          Icon(
            Directionality.of(context) == TextDirection.ltr
                ? Icons.chevron_right
                : Icons.chevron_left,
          ),
      subtitle: subtitle,
      onTap: onTap,
    );
  }
}
