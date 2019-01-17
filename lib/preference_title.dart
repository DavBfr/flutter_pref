import 'package:flutter/material.dart';

class PreferenceTitle extends StatelessWidget {
  final String title;
  final TextStyle style;

  PreferenceTitle(this.title, {this.style});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, bottom: 0.0, top: 20.0),
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
