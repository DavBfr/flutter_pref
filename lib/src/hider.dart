// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class PreferenceHider extends StatelessWidget {
  const PreferenceHider(
    this.preferences,
    this.hidePref, {
    this.defaultVal = true,
  });

  final List<Widget> preferences;
  final String hidePref;
  final bool defaultVal;

  @override
  Widget build(BuildContext context) {
    if (PrefService.of(context).getBool(hidePref) ?? defaultVal) {
      return Container();
    }

    return Column(
      children: preferences,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
