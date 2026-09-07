import 'package:material_ui/material_ui.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.colors = Colors.primaries,
    this.itemSize = 44.0,
    this.spacing = 8.0,
    this.runSpacing = 8.0,
  }) : super(key: key);

  final Color pickerColor;

  final ValueChanged<Color> onColorChanged;

  final List<Color> colors;

  final double itemSize;

  final double spacing;

  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      alignment: WrapAlignment.center,
      children: [
        for (final color in colors)
          _ColorSquare(
            color: color,
            isSelected: color.toARGB32() == pickerColor.toARGB32(),
            size: itemSize,
            onTap: () => onColorChanged(color),
          ),
      ],
    );
  }
}

class _ColorSquare extends StatelessWidget {
  const _ColorSquare({
    Key? key,
    required this.color,
    required this.isSelected,
    required this.size,
    required this.onTap,
  }) : super(key: key);

  final Color color;
  final bool isSelected;
  final double size;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final checkColor =
        color.computeLuminance() > 0.5 ? Colors.black : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          border: isSelected
              ? Border.all(
                  color: checkColor,
                  width: 2,
                )
              : null,
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                color: checkColor,
                size: size * 0.6,
              )
            : null,
      ),
    );
  }
}
