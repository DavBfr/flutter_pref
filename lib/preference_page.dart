import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class PreferencePage extends StatefulWidget {
  final List preferences;
  PreferencePage(this.preferences);

  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PrefService.init(),
      builder: (contenxt, snapshot) {
        if (!snapshot.hasData) return Container();
        print(widget.preferences.length);

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
