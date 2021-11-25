import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:pref/pref.dart';

// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_constructors_in_immutables
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: public_member_api_docs

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.loggerName} ${record.level.name}: ${record.message}');
  });

  // This PrefService is in memory only.
  // Use PrefServiceShared.init() to store the settings permanantly
  final service = PrefServiceCache();
  service.makeSecret('user_email'); // Prevent the logger to display the value
  await service.setDefaultValues(<String, dynamic>{
    'user_description': 'This is my description!',
    'advanced_enabled': false,
    'start_page': 'Timeline',
    'notification_pm_friend': true,
    'notification_newpost_friend': true,
    'notification_pm_stranger': false,
    'ui_theme': 'light',
    'user_email': 'email@gmail.com',
    'gender': 2,
    'content_show_text': false,
    'content_show_image': true,
    'content_show_audio': null,
    'android_listpref_selected': 'select_3',
    'android_listpref_auto_selected': null,
    'android_multilistpref_a': false,
    'android_multilistpref_b': true,
    'android_multilistpref_c': true,
    'exp_showos': false,
    'age': 65,
    'weight': 60,
  });

  runApp(MyApp(service));
}

class MyApp extends StatefulWidget {
  const MyApp(this.service, {Key? key}) : super(key: key);

  final BasePrefService service;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode? _brightness;

  StreamSubscription<String>? _stream;

  @override
  void dispose() {
    _stream?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _stream ??= widget.service.stream<String>('ui_theme').listen((event) {
      setState(() {
        switch (event) {
          case 'system':
            _brightness = ThemeMode.system;
            break;
          case 'light':
            _brightness = ThemeMode.light;
            break;
          case 'dark':
            _brightness = ThemeMode.dark;
            break;
        }
      });
    });

    return PrefService(
      service: widget.service,
      child: MaterialApp(
        title: 'Pref Demo',
        themeMode: _brightness,
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: MyHomePage(title: 'Pref Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

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
      body: PrefPage(
        children: [
          PrefTitle(title: Text('General')),
          PrefDropdown<String>(
            title: Text('Start Page'),
            pref: 'start_page',
            items: [
              DropdownMenuItem(value: 'Home', child: Icon(Icons.home)),
              DropdownMenuItem(value: 'Timeline', child: Icon(Icons.timeline)),
              DropdownMenuItem(value: 'Messages', child: Icon(Icons.message)),
            ],
          ),
          PrefDropdown<int>(
            title: Text('Number of items'),
            pref: 'items_count',
            fullWidth: false,
            items: [
              DropdownMenuItem(value: 1, child: Text('One')),
              DropdownMenuItem(value: 2, child: Text('Two')),
              DropdownMenuItem(value: 3, child: Text('Three')),
              DropdownMenuItem(value: 4, child: Text('Four')),
            ],
          ),
          PrefTitle(title: Text('Personalization')),
          PrefRadio<String>(
            title: Text('System Theme'),
            value: 'system',
            pref: 'ui_theme',
          ),
          PrefRadio<String>(
            title: Text('Light Theme'),
            value: 'light',
            pref: 'ui_theme',
          ),
          PrefRadio(
            title: Text('Dark Theme'),
            value: 'dark',
            pref: 'ui_theme',
          ),
          PrefTitle(title: Text('Messaging')),
          PrefPageButton(
            title: Text('Notifications'),
            leading: Icon(Icons.message),
            page: PrefPage(
              cache: true,
              children: [
                PrefTitle(title: Text('New Posts')),
                PrefSwitch(
                  title: Text('New Posts from Friends'),
                  pref: 'notification_newpost_friend',
                ),
                PrefDisabler(
                  pref: 'notification_newpost_friend',
                  reversed: true,
                  children: [
                    PrefTitle(title: Text('Private Messages')),
                    PrefSwitch(
                      title: Text('Private Messages from Friends'),
                      pref: 'notification_pm_friend',
                    ),
                    PrefSwitch(
                      title: Text('Private Messages from Strangers'),
                      pref: 'notification_pm_stranger',
                      onChange: (value) async {
                        debugPrint(
                            'notification_pm_stranger changed to: $value');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          PrefTitle(title: Text('User')),
          PrefText(
            label: 'Display Name',
            pref: 'user_display_name',
          ),
          PrefText(
            label: 'E-Mail',
            pref: 'user_email',
            validator: (str) {
              if (str == null || !str.endsWith('@gmail.com')) {
                return 'Invalid email';
              }
              return null;
            },
          ),
          PrefButtonGroup<int>(
            title: Text('Gender'),
            pref: 'gender',
            items: [
              ButtonGroupItem(value: 1, child: Text('Male')),
              ButtonGroupItem(value: 2, child: Text('Female')),
              ButtonGroupItem(value: 3, child: Text('Other')),
            ],
          ),
          PrefSlider<int>(
            title: Text('Your age'),
            pref: 'age',
            trailing: (num v) => SizedBox(width: 50, child: Text('I\'m $v')),
            min: 10,
            max: 90,
          ),
          PrefSlider<int>(
            title: Text('Person weight (metric)'),
            subtitle: Text('Demonstrating a long title and wide scale slider'),
            pref: 'weight',
            trailing: (num v) => Text('Weighs $v kilogram'),
            min: 10,
            max: 250,
            direction: Axis.vertical,
          ),
          PrefLabel(
            title: Text(
              PrefService.of(context).get<String>('user_description') ?? '',
              style: TextStyle(color: Colors.pink),
            ),
          ),
          PrefDialogButton(
            title: Text('Edit description'),
            dialog: PrefDialog(
              title: Text('Edit description'),
              cancel: Text('Cancel'),
              submit: Text('Save'),
              children: [
                PrefText(
                  label: 'Description',
                  pref: 'user_description',
                  padding: EdgeInsets.only(top: 8.0),
                  autofocus: true,
                  maxLines: 2,
                )
              ],
            ),
            onPop: () => setState(() {}),
          ),
          PrefTitle(title: Text('Content')),
          PrefDialogButton(
            title: Text('Content Types'),
            dialog: PrefDialog(
              title: Text('Enabled Content Types'),
              cancel: Icon(Icons.cancel),
              submit: Icon(Icons.save),
              children: [
                PrefCheckbox(
                  title: Text('Text'),
                  pref: 'content_show_text',
                ),
                PrefCheckbox(
                  title: Text('Images'),
                  pref: 'content_show_image',
                ),
                PrefCheckbox(
                  title: Text('Music'),
                  pref: 'content_show_audio',
                )
              ],
            ),
          ),
          PrefButton(
            onTap: () => debugPrint('DELETE!'),
            color: Colors.red,
            child: Text('Delete'),
          ),
          PrefTitle(title: Text('More Dialogs')),
          PrefChoice<String>(
            title: Text('Android\'s "ListPreference"'),
            pref: 'android_listpref_selected',
            items: [
              DropdownMenuItem(value: 'select_1', child: Text('Select me!')),
              DropdownMenuItem(value: 'select_2', child: Text('Hello World!')),
              DropdownMenuItem(value: 'select_3', child: Text('Test')),
            ],
            cancel: Text('Cancel'),
          ),
          PrefDialogButton(
            title: Text('Android\'s "ListPreference" with autosave'),
            dialog: PrefDialog(
              title: Text('Select an option'),
              submit: Text('Close'),
              children: [
                PrefRadio(
                  title: Text('Select me!'),
                  value: 'select_1',
                  pref: 'android_listpref_auto_selected',
                ),
                PrefRadio(
                  title: Text('Hello World!'),
                  value: 'select_2',
                  pref: 'android_listpref_auto_selected',
                ),
                PrefRadio(
                  title: Text('Test'),
                  value: 'select_3',
                  pref: 'android_listpref_auto_selected',
                ),
              ],
            ),
          ),
          PrefDialogButton(
            title: Text('Android\'s "MultiSelectListPreference"'),
            dialog: PrefDialog(
              title: Text('Select multiple options'),
              cancel: Text('Cancel'),
              submit: Text('Save'),
              children: [
                PrefCheckbox(
                  title: Text('A enabled'),
                  pref: 'android_multilistpref_a',
                ),
                PrefCheckbox(
                  title: Text('B enabled'),
                  pref: 'android_multilistpref_b',
                ),
                PrefCheckbox(
                  title: Text('C enabled'),
                  pref: 'android_multilistpref_c',
                ),
              ],
            ),
          ),
          PrefTitle(title: Text('Advanced')),
          PrefCheckbox(
            title: Text('Enable Advanced Features'),
            pref: 'advanced_enabled',
            onChange: (value) {
              setState(() {});
              if (!value) {
                PrefService.of(context).set('exp_showos', false);
              }
            },
          ),
          PrefHider(
            pref: 'advanced_enabled',
            children: [
              PrefSwitch(
                title: Text('Show Operating System'),
                pref: 'exp_showos',
                subtitle: Text(
                    'This option shows the users operating system in his profile'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
