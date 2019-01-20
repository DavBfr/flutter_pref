import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class PreferencePage extends StatefulWidget {
  final List preferences;
  PreferencePage(this.preferences);

  PreferencePageState createState() => PreferencePageState();
}

class PreferencePageState extends State<PreferencePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PrefService.init(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Container();

        return ListView.builder(
          itemCount: widget.preferences.length,
          itemBuilder: (context, i) {
            return widget.preferences[i];
          },
        );
      },
    );
  }
}
