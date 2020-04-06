import 'package:flutter/material.dart';

import 'preference_service.dart';

class DropdownPreference<T> extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final T defaultVal;

  final List<T> values;
  final List<String> displayValues;

  final Function onChange;

  final bool disabled;

  const DropdownPreference(
    this.title,
    this.localKey, {
    Key key,
    this.desc,
    this.defaultVal,
    @required this.values,
    this.displayValues,
    this.onChange,
    this.disabled = false,
  }) : super(key: key);

  @override
  _DropdownPreferenceState<T> createState() => _DropdownPreferenceState<T>();
}

class _DropdownPreferenceState<T> extends State<DropdownPreference<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = PrefService.of(context);
    if (service.get(widget.localKey) == null) {
      service.set(widget.localKey, widget.defaultVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.values.map((var val) {
      return DropdownMenuItem<T>(
        value: val,
        child: Text(
          widget.displayValues == null
              ? val.toString()
              : widget.displayValues[widget.values.indexOf(val)],
          textAlign: TextAlign.end,
        ),
      );
    }).toList();

    print(items);

    print('value: ${PrefService.of(context).get(widget.localKey)}');
    print('${PrefService.of(context).runtimeType}');

    final T value =
        PrefService.of(context).get(widget.localKey) ?? widget.defaultVal;

    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: DropdownButton<T>(
        items: items,
        onChanged: widget.disabled
            ? null
            : (newVal) async {
                onChange(newVal);
              },
        value: value,
      ),
    );
  }

  void onChange(T val) {
    setState(() {
      PrefService.of(context).set(widget.localKey, val);
    });

    if (widget.onChange != null) widget.onChange(val);
  }
}
