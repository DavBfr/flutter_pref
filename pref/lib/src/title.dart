// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'disabler.dart';

/// A single fixed-height row that typically contains some text as well as
/// an optional leading icon.
class PrefTitle extends StatelessWidget {
  /// Creates a preference title.
  const PrefTitle({
    super.key,
    required this.title,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
    this.margin,
    this.padding,
  });

  /// The primary content of the Title.
  final Widget title;

  /// The decoration applied.
  final Decoration? decoration;

  /// A widget to display before the title.
  final Widget? leading;

  /// Additional content displayed below the title.
  final Widget? subtitle;

  /// Called when the user taps this title.
  final Function? onTap;

  /// Empty space to inscribe inside the [decoration]. The title, if any, is
  /// placed inside this padding.
  final EdgeInsetsGeometry? padding;

  /// Empty space to surround the [decoration] and the Title.
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final disabled = PrefDisableState.of(context)?.disabled ?? false;

    final theme = Theme.of(context);
    final style = theme.textTheme.headlineSmall!.apply(
      color: disabled ? theme.disabledColor : theme.colorScheme.secondary,
    );

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.only(left: 10, bottom: 0, top: 20),
      decoration: decoration,
      child: ListTile(
        enabled: !disabled,
        leading: leading,
        onTap: onTap as void Function()?,
        title: DefaultTextStyle.merge(
          overflow: TextOverflow.ellipsis,
          style: style,
          child: title,
        ),
        subtitle: subtitle,
      ),
    );
  }
}
