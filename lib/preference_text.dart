import 'package:flutter/material.dart';

class PreferenceText extends StatelessWidget {
  final String text;

  final TextStyle style;
  final Decoration decoration;
  PreferenceText(this.text, {this.style, this.decoration});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: decoration,
      child: ListTile(
        title: Text(
          text,
          style: style,
        ),
      ),
    );
  }
}
