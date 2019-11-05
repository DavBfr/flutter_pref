import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class RadioPreference extends StatefulWidget {
  final String title;
  final String desc;
  final dynamic val;
  final String localGroupKey;
  final bool selected;
  final bool isDefault;

  final Function onSelect;
  final bool ignoreTileTap;

  final bool disabled;

  final leading;

  RadioPreference(
    this.title,
    this.val,
    this.localGroupKey, {
    this.desc,
    this.selected = false,
    this.ignoreTileTap = false,
    this.isDefault = false,
    this.onSelect,
    this.disabled = false,
    this.leading,
  });

  _RadioPreferenceState createState() => _RadioPreferenceState();
}

class _RadioPreferenceState extends State<RadioPreference> {
  BuildContext context;

  @override
  initState() {
    super.initState();
    PrefService.onNotify(widget.localGroupKey, () {
      try {
        setState(() {});
      } catch (e) {}
    });
  }

  @override
  dispose() {
    super.dispose();
    PrefService.onNotifyRemove(widget.localGroupKey);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isDefault && PrefService.get(widget.localGroupKey) == null) {
      onChange(widget.val);
    }

    this.context = context;
    return ListTile(
      title: Text(widget.title),
      leading: widget.leading,
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: Radio(
        value: widget.val,
        groupValue: PrefService.get(widget.localGroupKey),
        onChanged: widget.disabled ? null : (var val) => onChange(widget.val),
      ),
      onTap: (widget.ignoreTileTap || widget.disabled)
          ? null
          : () => onChange(widget.val),
    );
  }

  onChange(var val) {
    if (val is String) {
      setState(() => PrefService.setString(widget.localGroupKey, val));
    } else if (val is int) {
      setState(() => PrefService.setInt(widget.localGroupKey, val));
    } else if (val is double) {
      setState(() => PrefService.setDouble(widget.localGroupKey, val));
    } else if (val is bool) {
      setState(() => PrefService.setBool(widget.localGroupKey, val));
    }
    PrefService.notify(widget.localGroupKey);

    if (widget.onSelect != null) widget.onSelect();
  }
}
