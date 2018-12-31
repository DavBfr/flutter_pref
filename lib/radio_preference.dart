import 'package:flutter/material.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_service.dart';

class RadioPreference extends StatefulWidget {
  final String title;
  final String desc;
  final String val;
  final String localGroupKey;
  final bool selected;
  final bool isDefault;

  final Function onChange;
  final Function onSelect;
  final Function onDeselect;
  final bool ignoreTileTap;

  RadioPreference(
    this.title,
    this.val,
    this.localGroupKey, {
    this.desc,
    this.selected = false,
    this.ignoreTileTap = false,
    this.isDefault = false,
    this.onChange,
    this.onSelect,
    this.onDeselect,
  });

  _RadioPreferenceState createState() => _RadioPreferenceState();
}

class _RadioPreferenceState extends State<RadioPreference> {
  BuildContext context;

  @override
  initState() {
    super.initState();
    PrefService.onNotify(widget.localGroupKey, () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    print('building radio preference');

    if (widget.isDefault && PrefService.get(widget.localGroupKey) == null) {
      onChange(widget.val);
    }

    this.context = context;
    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: Radio(
        value: widget.val,
        groupValue: PrefService.get(widget.localGroupKey),
        onChanged: (var val) => onChange(widget.val),
      ),
      onTap: widget.ignoreTileTap ? null : () => onChange(widget.val),
    );
  }

  onChange(var val) {
    print('onChange');
    if (widget.onChange != null) widget.onChange(val);

    if (val is String) {
      setState(() => PrefService.setString(widget.localGroupKey, val));
    } else if (val is int) {
      setState(() => PrefService.setInt(widget.localGroupKey, val));
    } else if (val is double) {
      setState(() => PrefService.setDouble(widget.localGroupKey, val));
    } else if (val is bool) {
      setState(() => PrefService.setBool(widget.localGroupKey, val));
    }
    context
        .ancestorStateOfType(const TypeMatcher<PreferencePageState>())
        .setState(() {});
    PrefService.notify(widget.localGroupKey);
    onSelect(val);

/*     if (val != widget.val &&
        widget.val == PrefService.get(widget.localGroupKey)) {
      onDeselect(val);
    } else if (val == widget.val) {
      onSelect(val);
    } else {
      this.setState(() {});
    }
    print('setState'); */
    /* context
        .ancestorStateOfType(const TypeMatcher<PreferencePageState>())
        .setState(() {}); */
  }

  onSelect(var val) {
    if (widget.onSelect != null) widget.onSelect(val);

    /*   if (val is String) {
      setState(() => PrefService.setString(widget.localGroupKey, val));
    } else if (val is int) {
      setState(() => PrefService.setInt(widget.localGroupKey, val));
    } else if (val is double) {
      setState(() => PrefService.setDouble(widget.localGroupKey, val));
    } else if (val is bool) {
      setState(() => PrefService.setBool(widget.localGroupKey, val));
    } */
  }

  onDeselect(var val) {
    if (widget.onDeselect != null) widget.onDeselect(val);
    this.setState(() {});
  }
}
