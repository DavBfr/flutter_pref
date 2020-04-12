import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

/// PreferencePage isn't required if you init PrefService in your main() function
class PreferencePage extends StatefulWidget {
  final List<Widget> preferences;
  PreferencePage(this.preferences);

  PreferencePageState createState() => PreferencePageState();
}

class PreferencePageState extends State<PreferencePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPrefService.init(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        return PrefService(
          service: snapshot.data,
          child: ListView(children: widget.preferences),
        );
      },
    );
  }
}
