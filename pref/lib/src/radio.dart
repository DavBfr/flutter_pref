// Copyright (c) 2020, David PHAM-VAN <dev.nfet.net@gmail.com>
// All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'disabler.dart';
import 'log.dart';
import 'service/pref_service.dart';

class PrefRadio<T> extends StatefulWidget {
  const PrefRadio({
    this.title,
    required this.value,
    required this.pref,
    super.key,
    this.subtitle,
    this.selected = false,
    this.ignoreTileTap = false,
    this.onSelect,
    this.disabled,
    this.leading,
    this.radioFirst = false,
  }) : assert(value != null);

  final Widget? title;

  final Widget? subtitle;

  final T value;

  final String pref;

  final bool selected;

  final Function? onSelect;

  final bool ignoreTileTap;

  final bool? disabled;

  final bool radioFirst;

  final Widget? leading;

  @override
  PrefRadioState createState() => PrefRadioState<T>();
}

class PrefRadioState<T> extends State<PrefRadio<T>> {
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

  void _onChange(T value) {
    PrefService.of(context, listen: false).set(widget.pref, value);

    if (widget.onSelect != null) {
      widget.onSelect!();
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    final dynamic value = PrefService.of(context).get<dynamic>(widget.pref);
    properties.add(
      DiagnosticsProperty(
        'pref',
        value,
        description: '${widget.pref} = $value',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    T? value;
    try {
      value = PrefService.of(context).get(widget.pref);
    } catch (e, s) {
      logger.severe('Unable to load the value', e, s);
    }

    final disabled =
        widget.disabled ?? PrefDisableState.of(context)?.disabled ?? false;

    final radio = _Radio<T>(
      value: widget.value,
      groupValue: value,
      onChanged: disabled ? null : (T? val) => _onChange(widget.value),
    );

    if (widget.radioFirst) {
      return ListTile(
        enabled: !disabled,
        title: widget.title,
        trailing: widget.leading,
        subtitle: widget.subtitle,
        leading: radio,
        onTap: (widget.ignoreTileTap || disabled)
            ? null
            : () => _onChange(widget.value),
      );
    }

    return ListTile(
      enabled: !disabled,
      title: widget.title,
      leading: widget.leading,
      subtitle: widget.subtitle,
      trailing: radio,
      onTap: (widget.ignoreTileTap || disabled)
          ? null
          : () => _onChange(widget.value),
    );
  }
}

class _Radio<T> extends StatefulWidget {
  const _Radio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.focusNode,
    this.autofocus = false,
  });

  final T value;

  final T? groupValue;

  final ValueChanged<T?>? onChanged;

  final FocusNode? focusNode;

  final bool autofocus;

  @override
  State<_Radio<T>> createState() => _RadioState<T>();
}

class _RadioState<T> extends State<_Radio<T>> {
  bool _focused = false;
  bool _hovered = false;

  bool get _selected => widget.value == widget.groupValue;
  bool get _enabled => widget.onChanged != null;

  void _handleTap() {
    if (_enabled) {
      widget.onChanged?.call(widget.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color activeColor;
    final Color inactiveColor;

    if (_enabled) {
      activeColor = colorScheme.primary;
      inactiveColor = colorScheme.outline;
    } else {
      activeColor = theme.disabledColor;
      inactiveColor = theme.disabledColor;
    }

    final ringColor = _selected ? activeColor : inactiveColor;

    return Semantics(
      inMutuallyExclusiveGroup: true,
      selected: _selected,
      enabled: _enabled,
      child: FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        enabled: _enabled,
        onShowFocusHighlight: (value) => setState(() => _focused = value),
        onShowHoverHighlight: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _handleTap(),
          ),
        },
        mouseCursor: _enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: _enabled ? _handleTap : null,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 40,
            height: 40,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (_focused || _hovered)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _focused ? theme.focusColor : theme.hoverColor,
                      ),
                    ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: ringColor, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: _selected
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: activeColor,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
