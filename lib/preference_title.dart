import 'package:flutter/material.dart';

class PreferenceTitle extends StatelessWidget {
  final String title;
  TextStyle style;

  PreferenceTitle(this.title, {this.style});
  @override
  Widget build(BuildContext context) {
    if (style == null)
      style = TextStyle(
          color: Theme.of(context).accentColor, fontWeight: FontWeight.bold);

    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 20.0),
      child: Text(
        title,
        style: style,
      ),
    );
  }
}
