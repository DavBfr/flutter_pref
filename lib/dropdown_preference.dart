import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class DropdownPreference<T> extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final T defaultVal;

  final List<T> values;
  final List<String> displayValues;

  final Function onChange;

  final bool disabled;

  DropdownPreference(
    this.title,
    this.localKey, {
    this.desc,
    @required this.defaultVal,
    @required this.values,
    this.displayValues,
    this.onChange,
    this.disabled = false,
  });

  _DropdownPreferenceState createState() => _DropdownPreferenceState();
}

class _DropdownPreferenceState<T> extends State<DropdownPreference<T>> {
  @override
  void initState() {
    super.initState();
    if (PrefService.get(widget.localKey) == null) {
      PrefService.setDefaultValues({widget.localKey: widget.defaultVal});
    }
  }

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
                  ? val.toString()
                  : widget.displayValues[widget.values.indexOf(val)],
              textAlign: TextAlign.end,
            ),
          );
        }).toList(),
        onChanged: widget.disabled
            ? null
            : (newVal) async {
                onChange(newVal);
              },
        value: PrefService.get(widget.localKey) ?? widget.defaultVal,
      ),
    );
  }

  onChange(T val) {
    if (val is String) {
      this.setState(() => PrefService.setString(widget.localKey, val));
    } else if (val is int) {
      this.setState(() => PrefService.setInt(widget.localKey, val));
    } else if (val is double) {
      this.setState(() => PrefService.setDouble(widget.localKey, val));
    } else if (val is bool) {
      this.setState(() => PrefService.setBool(widget.localKey, val));
    }
    if (widget.onChange != null) widget.onChange(val);
  }
}
