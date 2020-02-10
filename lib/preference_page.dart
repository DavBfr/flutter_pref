import 'package:flutter/material.dart';

import 'preference_service.dart';
import 'preference_service_shared.dart';

/// PreferencePage isn't required if you init PrefService in your main() function
class PreferencePage extends StatefulWidget {
  final List<Widget> preferences;
  const PreferencePage(this.preferences);

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
          return SizedBox();
        }

        return PrefService(
          service: service,
          child: snapshot.data,
        );
      },
    );
  }
}
