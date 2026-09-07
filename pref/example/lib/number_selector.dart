import 'dart:math' show min, max;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'debouncer.dart';

class NumberSelector extends StatefulWidget {
  const NumberSelector({
    super.key,
    this.max,
    this.min,
    this.step = 1,
    this.enabled = true,
    this.onUpdate,
    this.current = 0,
    this.height = 50.0,
    this.width = 350.0,
    this.contentPadding = 20.0,
    this.verticalDividerPadding = 5.0,
    this.borderRadius = 2.0,
    this.borderColor = Colors.black26,
    this.dividerColor = Colors.black12,
    this.backgroundColor = Colors.white,
    this.borderWidth = 1.0,
    this.iconColor = Colors.black54,
    this.incrementIcon = Icons.chevron_right,
    this.decrementIcon = Icons.chevron_left,
    this.maxIcon = Icons.last_page,
    this.minIcon = Icons.first_page,
    this.showMinMax = true,
    this.showSuffix = true,
    this.hasCenteredText = false,
    this.hasDividers = true,
    this.hasBorder = true,
    this.prefixNaming = 'of',
    this.incrementTooltip = 'Increment',
    this.decrementTooltip = 'Decrement',
    this.maxTooltip = 'Max',
    this.minTooltip = 'Min',
    this.textStyle,
    this.delayUpdate = Duration.zero,
  });

  factory NumberSelector.plain({
    Key? key,
    int? max,
    int? min,
    int step = 1,
    bool enabled = true,
    Function(int number)? onUpdate,
    int current = 0,
    double height = 50.0,
    double width = 200.0,
    double contentPadding = 20.0,
    double verticalDividerPadding = 5.0,
    double borderRadius = 2.0,
    Color borderColor = Colors.black26,
    Color dividerColor = Colors.black12,
    Color backgroundColor = Colors.transparent,
    double borderWidth = 1.0,
    Color iconColor = Colors.black54,
    IconData incrementIcon = Icons.add,
    IconData decrementIcon = Icons.remove,
    IconData maxIcon = Icons.last_page,
    IconData minIcon = Icons.first_page,
    bool showMinMax = true,
    bool showSuffix = true,
    bool hasCenteredText = true,
    bool hasDividers = false,
    bool hasBorder = false,
    String prefixNaming = 'of',
    String? incrementTooltip,
    String? decrementTooltip,
    String? maxTooltip,
    String? minTooltip,
    TextStyle? textStyle,
    Duration delayUpdate = Duration.zero,
  }) => NumberSelector(
    key: key,
    max: max,
    min: min,
    step: step,
    enabled: enabled,
    onUpdate: onUpdate,
    current: current,
    height: height,
    width: width,
    contentPadding: contentPadding,
    verticalDividerPadding: verticalDividerPadding,
    borderRadius: borderRadius,
    borderColor: borderColor,
    dividerColor: dividerColor,
    backgroundColor: backgroundColor,
    borderWidth: borderWidth,
    iconColor: iconColor,
    incrementIcon: incrementIcon,
    decrementIcon: decrementIcon,
    maxIcon: maxIcon,
    minIcon: minIcon,
    showMinMax: showMinMax,
    showSuffix: showSuffix,
    hasCenteredText: hasCenteredText,
    hasDividers: hasDividers,
    hasBorder: hasBorder,
    prefixNaming: prefixNaming,
    incrementTooltip: incrementTooltip,
    decrementTooltip: decrementTooltip,
    maxTooltip: maxTooltip,
    minTooltip: minTooltip,
    textStyle: textStyle,
    delayUpdate: delayUpdate,
  );

  /// Maximum selectable value
  final int? max;

  /// Minimum selectable value
  final int? min;

  /// Startindex of selector
  /// If not set, the selector will start at 0
  final int current;

  /// The amount every increment/decrement will be
  /// Default is 1
  final int step;

  /// Provide false to disable the entire selector
  final bool enabled;

  /// Callback on number change
  final Function(int number)? onUpdate;

  /// Default is 36.0 px
  final double height;

  /// Default to 324.0 px. Provide null to expand to parent width
  final double? width;

  /// Default is 2.0 px
  final double borderRadius;

  /// Default is Colors.black26
  final Color borderColor;

  /// Default is Colors.black12
  final Color dividerColor;

  /// Default is Colors.white
  final Color backgroundColor;

  /// Default is 1.0 px
  final double borderWidth;

  /// Shows or hides the outline of the selector
  final bool hasBorder;

  /// Default is Colors.black54
  final Color iconColor;

  /// Increment icon
  final IconData incrementIcon;

  /// Decrement icon
  final IconData decrementIcon;

  /// Maximal number icon
  final IconData maxIcon;

  /// Minimal number icon
  final IconData minIcon;

  /// Show min and max buttons if min and max are set
  /// Default is true
  final bool showMinMax;

  /// Show suffix if max is set
  /// Default is true
  final bool showSuffix;

  /// Center text in the textfield
  /// Default is false
  final bool hasCenteredText;

  /// Show or hide the lines between the buttons
  /// Default is true
  final bool hasDividers;

  /// The String displayed before the max number in the textField
  /// Default is 'of'
  final String prefixNaming;

  /// The spacing between the number and the buttons
  final double contentPadding;

  /// The spacing between vertical deviders and the main container
  /// Default is 5.0 px
  final double verticalDividerPadding;

  /// Tooltip for the increment button
  final String? incrementTooltip;

  /// Tooltip for the decrement button
  final String? decrementTooltip;

  /// Tooltip for the max button
  final String? maxTooltip;

  /// Tooltip for the min button
  final String? minTooltip;

  /// The TextStyle of the number
  final TextStyle? textStyle;

  /// Delays the execution of the onUpdate callback
  final Duration delayUpdate;

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  late final FocusNode _focusNode;
  late final TextEditingController _controller;
  late final Debouncer _debouncer;

  late int _current;
  bool _isCanceled = false;

  @override
  void initState() {
    _current = widget.current;
    _focusNode = FocusNode();
    _controller = TextEditingController(text: '${widget.current}');
    _debouncer = Debouncer(duration: widget.delayUpdate);

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.enabled) {
        _updateOrCancel(_parcedText);
      }
    });

    _focusNode.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _isCanceled = true;
        _focusNode.unfocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };

    super.initState();
  }

  @override
  void didUpdateWidget(covariant NumberSelector oldWidget) {
    if (oldWidget.current != widget.current) {
      _current = widget.current;
      _controller.text = '${widget.current}';
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        border: widget.hasBorder
            ? Border.all(color: widget.borderColor, width: widget.borderWidth)
            : null,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.backgroundColor,
      ),
      child: Row(
        children: [
          if (widget.min != null && widget.showMinMax) ...[
            _NaviagtionButton(
              key: const Key('Min'),
              height: widget.height,
              width: widget.height,
              enabled: _isDecementEnabled,
              icon: Icon(widget.minIcon),
              iconColor: widget.iconColor,
              onPressed: () => _updateOrCancel(widget.min!),
              tooltip: widget.minTooltip,
            ),
            _divider(),
          ],
          _NaviagtionButton(
            key: const Key('Decrement'),
            height: widget.height,
            width: widget.height,
            enabled: _isDecementEnabled,
            icon: Icon(widget.decrementIcon),
            iconColor: widget.iconColor,
            onPressed: () => _updateOrCancel(_parcedText - 1),
            tooltip: widget.decrementTooltip,
          ),
          _divider(),
          Expanded(child: _numberField()),
          _divider(),
          _NaviagtionButton(
            key: const Key('Increment'),
            height: widget.height,
            width: widget.height,
            enabled: _isIncrementEnabled,
            icon: Icon(widget.incrementIcon),
            iconColor: widget.iconColor,
            onPressed: () => _updateOrCancel(_parcedText + 1),
            tooltip: widget.incrementTooltip,
          ),
          if (widget.max != null && widget.showMinMax) ...[
            _divider(),
            _NaviagtionButton(
              key: const Key('Max'),
              height: widget.height,
              width: widget.height,
              enabled: _isIncrementEnabled,
              icon: Icon(widget.maxIcon),
              iconColor: widget.iconColor,
              onPressed: () => _updateOrCancel(widget.max!),
              tooltip: widget.maxTooltip,
            ),
          ],
        ],
      ),
    );
  }

  Widget _numberField() {
    final showSuffix = widget.max != null && widget.showSuffix;
    return TextField(
      style: widget.textStyle,
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: '$_current',
        suffixText: showSuffix ? '${widget.prefixNaming} ${widget.max}' : null,
        contentPadding: EdgeInsets.symmetric(horizontal: widget.contentPadding),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        isDense: true,
      ),
      textAlign: widget.hasCenteredText ? TextAlign.center : TextAlign.start,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9-]'))],
      enabled: widget.enabled,
    );
  }

  Widget _divider() => widget.hasDividers
      ? Padding(
          padding: EdgeInsets.symmetric(
            vertical: widget.verticalDividerPadding,
          ),
          child: VerticalDivider(
            width: widget.borderWidth,
            thickness: widget.borderWidth,
            color: widget.dividerColor,
          ),
        )
      : const SizedBox();

  void _updateOrCancel(int number) {
    final clamped = _clamp(number);
    _canUpdate(clamped) ? _update(clamped) : _cancel();
  }

  bool _canUpdate(int number) => !_isCanceled && number != _current;

  void _update(int number) {
    _updateState(number);
    _updateCallBack(number);
  }

  void _updateState(int number) {
    setState(() {
      _current = number;
      _controller.text = '$number';
    });
  }

  void _updateCallBack(int number) {
    if (widget.delayUpdate == Duration.zero) {
      _onUpdate(number);
    } else {
      _debouncer.run(() => _onUpdate(number));
    }
  }

  void _onUpdate(int number) => widget.onUpdate?.call(_clamp(number));

  void _cancel() {
    setState(() {
      _isCanceled = false;
      _controller.text = '$_current';
    });
  }

  bool get _isDecementEnabled =>
      widget.enabled && (widget.min != null && _parcedText > widget.min!) ||
      widget.min == null;

  bool get _isIncrementEnabled =>
      widget.enabled && (widget.max != null && _parcedText < widget.max!) ||
      widget.max == null;

  int get _parcedText => int.tryParse(_controller.text) ?? _current;

  int _clamp(int number) {
    if (widget.min != null) {
      number = max(number, widget.min!);
    }
    if (widget.max != null) {
      number = min(number, widget.max!);
    }
    return number;
  }
}

class _NaviagtionButton extends StatelessWidget {
  const _NaviagtionButton({
    super.key,
    required this.height,
    required this.width,
    required this.icon,
    required this.onPressed,
    required this.iconColor,
    this.enabled = true,
    this.tooltip,
  });
  final double height;
  final double width;
  final Icon icon;
  final void Function()? onPressed;
  final bool enabled;
  final Color iconColor;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: icon,
          onPressed: enabled ? onPressed : null,
          color: iconColor,
          disabledColor: Colors.black26,
          tooltip: tooltip,
        ),
      ),
    );
  }
}
