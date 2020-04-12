import 'package:flutter/material.dart';

class PreferenceTitle extends StatelessWidget {
  final String title;
  final double leftPadding;
  final TextStyle style;

  const PreferenceTitle(this.title, {this.leftPadding = 10.0, this.style});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, bottom: 0.0, top: 20.0),
      child: Text(
        title,
        style: style ??
            TextStyle(
                color: Theme.of(context).accentColor,
                fontWeight: FontWeight.bold),
      ),
    );
  }
}
