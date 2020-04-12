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

  const DropdownPreference(
    this.title,
    this.localKey, {
    this.desc,
    @required this.defaultVal,
    @required this.values,
    this.displayValues,
    this.onChange,
    this.disabled = false,
  });

  _DropdownPreferenceState<T> createState() => _DropdownPreferenceState<T>();
}

class _DropdownPreferenceState<T> extends State<DropdownPreference<T>> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = PrefService.of(context);
    if (service.get(widget.localKey) == null) {
      service.setDefaultValues({widget.localKey: widget.defaultVal});
    }
  }

  @override
  Widget build(BuildContext context) {
    T value;
    try {
      value = PrefService.get(widget.localKey) ?? widget.defaultVal;
    } on TypeError catch (e) {
      value = widget.defaultVal;
      assert(() {
        throw FlutterError('''$e
The PrefService value for "${widget.localKey}" is not the right type (${PrefService.get(widget.localKey)}).
In release mode, the default value ($value) will silently be used.
''');
      }());
    }

    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: DropdownButton<T>(
        items: widget.values.map((var val) {
          return DropdownMenuItem<T>(
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
        value:
            PrefService.of(context).get(widget.localKey) ?? widget.defaultVal,
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
