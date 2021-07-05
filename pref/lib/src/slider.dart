// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'log.dart';
import 'service/pref_service.dart';

class PrefSlider<T extends num> extends StatefulWidget {
  const PrefSlider({
    Key? key,
    this.title,
    required this.pref,
    this.subtitle,
    this.ignoreTileTap = false,
    this.onChange,
    this.disabled = false,
    this.min,
    this.max,
    this.divisions,
    this.label,
    this.trailing,
    this.direction = Axis.horizontal,
  }) : super(key: key);

  final Widget? title;

  final Widget? subtitle;

  final String pref;

  final bool ignoreTileTap;

  final bool disabled;

  final T? min;

  final T? max;

  final int? divisions;

  final ValueChanged<T>? onChange;

  final String Function(T value)? label;

  final Widget Function(T value)? trailing;

  final Axis direction;

  @override
  _PrefSliderState createState() => _PrefSliderState<T>();
}

class _PrefSliderState<T extends num> extends State<PrefSlider> {
  @override
  void didChangeDependencies() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    PrefService.of(context).removeKeyListener(widget.pref, _onNotify);
    super.deactivate();
  }

  @override
  void reassemble() {
    PrefService.of(context).addKeyListener(widget.pref, _onNotify);
    super.reassemble();
  }

  void _onNotify() {
    setState(() {});
  }

  Future<void> _onChange(double value) async {
    final service = PrefService.of(context, listen: false);

    if (T == double) {
      service.set<double>(widget.pref, value);

      if (widget.onChange != null) {
        widget.onChange!(value);
      }
    } else if (T == int) {
      service.set<int>(widget.pref, value.round());

      if (widget.onChange != null) {
        widget.onChange!(value.round());
      }
    } else if (T == num) {
      service.set<double>(widget.pref, value);

      if (widget.onChange != null) {
        widget.onChange!(value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    T? value;
    try {
      value = PrefService.of(context).get<T>(widget.pref);
    } catch (e, s) {
      logger.severe('Unable to load the value', e, s);
    }

    final min = (widget.min ?? 0.0).toDouble();
    final max = (widget.max ?? 1.0).toDouble();
    // ignore: unnecessary_cast
    final doubleValue = (value as num? ?? min).toDouble();
    final label =
        widget.label != null && value != null ? widget.label!(value) : null;
    final trailing = widget.trailing != null && value != null
        ? widget.trailing!(value)
        : null;
    final slider = Slider(
      label: label,
      value: doubleValue,
      onChanged: _onChange,
      min: min,
      max: max,
      divisions: widget.divisions,
    );

    if (widget.direction == Axis.horizontal) {
      return ListTile(
        subtitle: widget.subtitle,
        trailing: trailing,
        title: Row(
          children: [
            if (widget.title != null) widget.title!,
            Expanded(child: slider),
          ],
        ),
      );
    }

    return ListTile(
      subtitle: widget.subtitle,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.title != null || trailing != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.title != null) widget.title!,
                if (trailing != null) trailing,
              ],
            ),
          slider,
        ],
      ),
    );
  }
}
