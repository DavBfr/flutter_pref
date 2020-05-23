// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'service/pref_service.dart';

class PrefText extends StatefulWidget {
  const PrefText({
    this.label,
    @required this.pref,
    Key key,
    this.onChange,
    this.validator,
    this.padding,
    this.obscureText = false,
    this.autofocus = false,
    this.hintText = '',
    this.maxLines = 1,
    this.style,
    this.keyboardType,
    this.labelStyle,
    this.decoration,
    this.disabled = false,
  })  : assert(pref != null),
        super(key: key);

  final String label;

  final String pref;

  final EdgeInsets padding;

  final bool autofocus;

  final int maxLines;

  final bool obscureText;

  final String hintText;

  final TextStyle style;

  final TextInputType keyboardType;

  final TextStyle labelStyle;

  final InputDecoration decoration;

  final ValueChanged<String> onChange;

  final String Function(String) validator;

  final bool disabled;

  @override
  _PrefTextState createState() => _PrefTextState();
}

class _PrefTextState extends State<PrefText> {
  TextEditingController controller = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    final service = PrefService.of(context);

    if (!_initialized) {
      try {
        controller.text = service.get<String>(widget.pref) ?? '';
      } catch (e) {
        print('Unable to load the value: $e');
      }

      _initialized = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ??
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Form(
        child: Builder(
          builder: (BuildContext context) => TextFormField(
            decoration: widget.decoration ??
                InputDecoration(
                  hintText: widget.hintText,
                  labelText: widget.label,
                  labelStyle: widget.labelStyle,
                ),
            controller: controller,
            onChanged: (val) {
              if (Form.of(context).validate()) {
                if (widget.onChange != null) {
                  widget.onChange(val);
                }
                PrefService.of(context).set(widget.pref, val);
              }
            },
            autofocus: widget.autofocus,
            maxLines: widget.maxLines,
            style: widget.style,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            validator: widget.validator,
            enabled: !widget.disabled,
          ),
        ),
      ),
    );
  }
}
