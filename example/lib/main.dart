import 'package:flutter/material.dart';
import 'package:preferences/preference_service.dart';
import 'package:preferences/preferences.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

main() async {
  await PrefService.init();

  runApp(MyApp(ThemeData(scaffoldBackgroundColor: Colors.yellow)));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;
  MyApp(this.theme);
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => theme,
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Preferences Demo',
            theme: theme,
            home: MyHomePage(title: 'Preferences Demo'),
          );
        });
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
    print('appBuild');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PreferencePage([
        /* 
        PrefService.getBool('vetretungen_filter_lastdays')
            ? Column(
                children: <Widget>[
                  PreferenceTitle('Benachrichtigungen'),
                  PreferenceTitle('Benachrichtigungen'),
                  PreferenceTitle('Benachrichtigungen'),
                  PreferenceTitle('Benachrichtigungen'),
                  PreferenceTitle('Benachrichtigungen'),
                ],
              )
            : Container(), */
        PreferenceTitle('Allgemein'),
        DropdownPreference(
          'Modus',
          'mode',
          defaultVal: 'Unter-/Mittelstufenschüler',
          values: [
            'Unter-/Mittelstufenschüler',
            'Oberstufenschüler',
            'Lehrer',
          ],
        ),
        PreferenceTitle('Vertretungen'),
        PreferenceTitle('Mensa Anemldung'),
        PreferenceTitle('LanisOnline'),
        PreferenceTitle('Mensa Benachrichtigungen'),
        PreferenceTitle('Fehlerreport'),
        PreferenceTitle('Thema'),
        RadioPreference(
          'Hell',
          'hell',
          'theme',
          onSelect: (val) {
            print('select light');
            DynamicTheme.of(context)
                .setThemeData(new ThemeData(primaryColor: Colors.red));
          },
        ),
        RadioPreference(
          'Dunkel',
          'dunkel',
          'theme',
          onSelect: (val) {
            print('select dark');
            DynamicTheme.of(context).setThemeData(new ThemeData.dark());
          },
        ),
        PreferenceHider([
          PreferenceTitle('Benachrichtigungen'),
          PreferenceTitle('Debug'),
        ], '!show_advanced'),
        PreferenceTitle('Erweitert'),
        SwitchPreference(
          'Erweiterte Optionen',
          'show_advanced',
          onEnable: () {
            setState(() {});
          },
          onDisable: () {
            setState(() {});
          },
        ),
        /* CheckboxPreference(
          'Vergangene Tage filtern',
          'vetretungen_filter_lastdays',
          /*    onEnable: () {
            print('onEnable');
            setState(() {});
          },
          onDisable: () {
            print('onDisable');
            setState(() {});
          }, */
        ), */
        /*   DropdownPreference('Handy', 'phone_type',
            values: ['Apple', 'Samsung', 'Google'], defaultVal: 'Apple'),
        PreferenceText(
          'Hier steht ein extrem wichtiger aufklärender Text',
          style: TextStyle(color: Colors.red, fontSize: 20.0),
          decoration: BoxDecoration(color: Colors.yellow),
        ), */
        /*   RadioPreference('Titel', 'val1', 'val'),
        RadioPreference('Titel', 'val2', 'val'),
        RadioPreference('Titel', 'val3', 'val'),
        RadioPreference('Titel', 'val4', 'val'),
        RadioPreference('Titel', 'val5', 'val'),
        SwitchPreference('Erweiterte Optionen', 'extended_options'),
        PreferencePageLink(
          'Termine',
          page: PreferencePage([
            PreferenceTitle('Benachrichtigungen'),
            SwitchPreference(
              'Vergangene Tage filtern',
              'vetretungen_filter_lastdays',
            ),
          ]),
          leading: Icon(Icons.assignment),
        ),
        Text(PrefService.getKeys().toString()) */
      ]),
    );
  }
}
