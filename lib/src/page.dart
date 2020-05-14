// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';
import 'service/shared_preferences.dart';

/// [PrefPage] isn't required if you init PrefService in your main() function
class PrefPage extends StatefulWidget {
  const PrefPage({
    @required this.children,
  }) : assert(children != null);

  final List<Widget> children;

  @override
  _PrefPageState createState() => _PrefPageState();
}

class _PrefPageState extends State<PrefPage> {
  @override
  Widget build(BuildContext context) {
    final settings = ListView(children: widget.children);

    // Check if we already have a BasePrefService
    final service = PrefService.of(context);
    if (service != null) {
      return settings;
    }

    // Fallback to SharedPreferences
    return FutureBuilder(
      future: PrefServiceShared.init(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        return PrefService(
          service: service,
          child: snapshot.data,
        );
      },
    );
  }
}
