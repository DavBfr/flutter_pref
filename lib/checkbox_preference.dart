import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class CheckboxPreference extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final bool defaultVal;
  final bool ignoreTileTap;

  final Function onEnable;
  final Function onDisable;

  CheckboxPreference(this.title, this.localKey,
      {this.desc,
      this.defaultVal = false,
      this.ignoreTileTap = false,
      this.onEnable,
      this.onDisable});

  _CheckboxPreferenceState createState() => _CheckboxPreferenceState();
}

class _CheckboxPreferenceState extends State<CheckboxPreference> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: Checkbox(
        value: PrefService.getBool(widget.localKey) ?? widget.defaultVal,
        onChanged: (val) => val ? onEnable() : onDisable(),
      ),
      onTap: widget.ignoreTileTap
          ? null
          : () => (PrefService.getBool(widget.localKey) ?? widget.defaultVal)
              ? onDisable()
              : onEnable(),
    );
  }

  onEnable() {
    if (widget.onEnable != null) widget.onEnable();
    this.setState(() => PrefService.setBool(widget.localKey, true));
  }

  onDisable() {
    if (widget.onDisable != null) widget.onDisable();
    this.setState(() => PrefService.setBool(widget.localKey, false));
  }
}
