import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchPreference extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final bool defaultVal;
  final bool ignoreTileTap;
  SwitchPreference(this.title, this.localKey,
      {this.desc, this.defaultVal = false, this.ignoreTileTap = false});

  _SwitchPreferenceState createState() => _SwitchPreferenceState();
}

class _SwitchPreferenceState extends State<SwitchPreference> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: Switch(
        value: PrefService.getBool(widget.localKey) ?? widget.defaultVal,
        onChanged: (val) =>
            setState(() => PrefService.setBool(widget.localKey, val)),
      ),
      onTap: widget.ignoreTileTap
          ? null
          : () => setState(() => PrefService.setBool(
              widget.localKey, !PrefService.getBool(widget.localKey))),
    );
  }
}
