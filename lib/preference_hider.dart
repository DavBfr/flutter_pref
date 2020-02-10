import 'package:flutter/material.dart';

import 'preference_service.dart';

class PreferenceHider extends StatelessWidget {
  final List<Widget> preferences;
  final String hidePref;
  final bool defaultVal;

  const PreferenceHider(this.preferences, this.hidePref,
      {this.defaultVal = true});

  @override
  Widget build(BuildContext context) {
    if (PrefService.of(context).getBool(hidePref) ?? defaultVal) {
      return Container();
    }

    return Column(
      children: preferences,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
