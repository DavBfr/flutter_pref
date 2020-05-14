// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';
import 'service/shared_preferences.dart';

/// PreferencePage isn't required if you init PrefService in your main() function
class PreferencePage extends StatefulWidget {
  const PreferencePage(this.preferences);

  final List<Widget> preferences;

  @override
  PreferencePageState createState() => PreferencePageState();
}

class PreferencePageState extends State<PreferencePage> {
  @override
  Widget build(BuildContext context) {
    final settings = ListView(children: widget.preferences);

    // Check if we already have a BasePrefService
    final service = PrefService.of(context);
    if (service != null) {
      return settings;
    }

    // Fallback to SharedPreferences
    return FutureBuilder(
      future: SharedPrefService.init(),
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
