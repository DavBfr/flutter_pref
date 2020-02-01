import 'package:flutter/material.dart';

class PreferenceText extends StatelessWidget {
  final String text;

  final TextStyle style;
  final Decoration decoration;

  final Widget leading;
  final Text subtitle;

  final Function onTap;

  PreferenceText(
    this.text, {
    this.style,
    this.decoration,
    this.leading,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ListTile(
        leading: leading,
        onTap: onTap,
        title: Text(
          text,
          style: style,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: subtitle,
      ),
    );
  }
}
