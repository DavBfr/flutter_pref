import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class DropdownPreference extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final dynamic defaultVal;

  final List values;
  final List displayValues;

  final Function onChange;

  DropdownPreference(
    this.title,
    this.localKey, {
    this.desc,
    @required this.defaultVal,
    @required this.values,
    this.displayValues,
    this.onChange,
  });

  _DropdownPreferenceState createState() => _DropdownPreferenceState();
}

class _DropdownPreferenceState extends State<DropdownPreference> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: DropdownButton(
        items: widget.values.map((var val) {
          return DropdownMenuItem(
            value: val,
            child: Text(
              widget.displayValues == null
                  ? val
                  : widget.displayValues[widget.values.indexOf(val)],
              textAlign: TextAlign.end,
            ),
          );
        }).toList(),
        onChanged: (newVal) async {
          onChange(newVal);
        },
        value: PrefService.get(widget.localKey) ?? widget.defaultVal,
      ),
    );
  }

  onChange(var val) {
    if (val is String) {
      this.setState(() => PrefService.setString(widget.localKey, val));
    } else if (val is int) {
      this.setState(() => PrefService.setInt(widget.localKey, val));
    } else if (val is double) {
      this.setState(() => PrefService.setDouble(widget.localKey, val));
    } else if (val is bool) {
      this.setState(() => PrefService.setBool(widget.localKey, val));
    }
    PrefService.notify(widget.localKey);
    if (widget.onChange != null) widget.onChange(val);
  }
}
