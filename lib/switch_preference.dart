import 'dart:async';

import 'package:flutter/material.dart';

import 'preference_service.dart';

class SwitchPreference extends StatefulWidget {
  final String title;
  final String desc;
  final String localKey;
  final bool defaultVal;
  final bool ignoreTileTap;

  final bool resetOnException;

  final Function onEnable;
  final Function onDisable;
  final Function onChange;

  final bool disabled;

  final Color switchActiveColor;

  const SwitchPreference(
    this.title,
    this.localKey, {
    this.desc,
    this.defaultVal = false,
    this.ignoreTileTap = false,
    this.resetOnException = true,
    this.onEnable,
    this.onDisable,
    this.onChange,
    this.disabled = false,
    this.switchActiveColor,
  });

  @override
  _SwitchPreferenceState createState() => _SwitchPreferenceState();
}

class _SwitchPreferenceState extends State<SwitchPreference> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final service = PrefService.of(context);

    if (service.getBool(widget.localKey) == null) {
      service.setBool(widget.localKey, widget.defaultVal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: widget.desc == null ? null : Text(widget.desc),
      trailing: Switch.adaptive(
        value: PrefService.of(context).getBool(widget.localKey) ??
            widget.defaultVal,
        activeColor: widget.switchActiveColor,
        onChanged:
            widget.disabled ? null : (val) => val ? onEnable() : onDisable(),
      ),
      onTap: (widget.disabled || widget.ignoreTileTap)
          ? null
          : () => (PrefService.of(context).getBool(widget.localKey) ??
                  widget.defaultVal)
              ? onDisable()
              : onEnable(),
    );
  }

  Future<void> onEnable() async {
    setState(() {
      PrefService.of(context).setBool(widget.localKey, true);
    });
    if (widget.onChange != null) widget.onChange();
    if (widget.onEnable != null) {
      try {
        await widget.onEnable();
      } catch (e) {
        if (widget.resetOnException) {
          PrefService.of(context).setBool(widget.localKey, false);
          if (mounted) setState(() {});
        }
        if (mounted) PrefService.showError(context, e.message);
      }
    }
  }

  Future<void> onDisable() async {
    setState(() {
      PrefService.of(context).setBool(widget.localKey, false);
    });
    if (widget.onChange != null) widget.onChange();
    if (widget.onDisable != null) {
      try {
        await widget.onDisable();
      } catch (e) {
        if (widget.resetOnException) {
          PrefService.of(context).setBool(widget.localKey, true);
          if (mounted) setState(() {});
        }
        if (mounted) PrefService.showError(context, e.message);
      }
    }
  }
}
