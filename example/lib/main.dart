import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preferences Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Preferences Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PreferencePage([
        PreferenceTitle('Benachrichtigungen'),
        SwitchPreference(
          'Vergangene Tage filtern',
          'vetretungen_filter_lastdays',
        ),
        PreferencePageLink(
            'Termine',
            PreferencePage([
              PreferenceTitle('Benachrichtigungen'),
              SwitchPreference(
                'Vergangene Tage filtern',
                'vetretungen_filter_lastdays',
              ),
            ]))
      ]),
    );
  }
}
