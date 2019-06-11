import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';

class TextFieldPreference extends StatefulWidget {
  final String label;
  final String localKey;
  final String defaultVal;
  final EdgeInsets padding;
  final bool autofocus;
  final int maxLines;

  final Function onChange;

  TextFieldPreference(this.label, this.localKey,
      {this.defaultVal,
      this.onChange,
      this.padding,
      this.autofocus = false,
      this.maxLines = 1});

  _DropdownPreferenceState createState() => _DropdownPreferenceState();
}

class _DropdownPreferenceState extends State<TextFieldPreference> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text =
        PrefService.getString(widget.localKey) ?? widget.defaultVal ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: TextField(
        decoration: InputDecoration(
            labelText: widget.label, border: OutlineInputBorder()),
        controller: controller,
        onChanged: (val) {
          if (widget.onChange != null) val = widget.onChange(val);
          PrefService.setString(widget.localKey, val);
        },
        autofocus: widget.autofocus,
        maxLines: widget.maxLines,
      ),
    );
  }
}
