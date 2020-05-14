import 'dart:async';
import 'package:flutter/material.dart';

import 'package:pref/pref.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final service = await SharedPrefService.init(prefix: 'pref_');
  service.setDefaultValues({'user_description': 'This is my description!'});

  runApp(MyApp(service));
}

class MyApp extends StatelessWidget {
  const MyApp(this.service);

  final BasePrefService service;

  @override
  Widget build(BuildContext context) {
    return PrefService(
      service: service,
      child: MaterialApp(
        title: 'Preferences Demo',
        home: MyHomePage(title: 'Preferences Demo'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

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
        PreferenceTitle('General'),
        DropdownPreference(
          'Start Page',
          'start_page',
          defaultVal: 'Timeline',
          values: ['Posts', 'Timeline', 'Private Messages'],
        ),
        DropdownPreference<int>(
          'Number of items',
          'items_count',
          defaultVal: 2,
          displayValues: ['One', 'Two', 'Three', 'Four'],
          values: [1, 2, 3, 4],
        ),
        PreferenceTitle('Personalization'),
        RadioPreference(
          'Light Theme',
          'light',
          'ui_theme',
          isDefault: true,
        ),
        RadioPreference(
          'Dark Theme',
          'dark',
          'ui_theme',
        ),
        PreferenceTitle('Messaging'),
        PreferencePageLink(
          'Notifications',
          leading: Icon(Icons.message),
          trailing: Icon(Icons.keyboard_arrow_right),
          page: PreferencePage([
            PreferenceTitle('New Posts'),
            SwitchPreference(
              'New Posts from Friends',
              'notification_newpost_friend',
              defaultVal: true,
            ),
            PreferenceTitle('Private Messages'),
            SwitchPreference(
              'Private Messages from Friends',
              'notification_pm_friend',
              defaultVal: true,
            ),
            SwitchPreference(
              'Private Messages from Strangers',
              'notification_pm_stranger',
              onEnable: () async {
                // Write something in Firestore or send a request
                await Future.delayed(Duration(seconds: 1));

                print('Enabled Notifications for PMs from Strangers!');
              },
              onDisable: () async {
                // Write something in Firestore or send a request
                await Future.delayed(Duration(seconds: 1));

                // No Connection? No Problem! Just throw an Exception with your custom message...
                throw Exception('No Connection');

                // Disabled Notifications for PMs from Strangers!
              },
            ),
          ]),
        ),
        PreferenceTitle('User'),
        TextFieldPreference(
          'Display Name',
          'user_display_name',
        ),
        TextFieldPreference(
          'E-Mail',
          'user_email',
          defaultVal: 'email@gmail.com',
          validator: (String str) {
            if (!str.endsWith('@gmail.com')) {
              return 'Invalid email';
            }
            return null;
          },
        ),
        PreferenceText(
          PrefService.of(context).getString('user_description') ?? '',
          style: TextStyle(color: Colors.grey),
        ),
        PreferenceDialogLink(
          'Edit description',
          dialog: PreferenceDialog(
            [
              TextFieldPreference(
                'Description',
                'user_description',
                padding: const EdgeInsets.only(top: 8.0),
                autofocus: true,
                maxLines: 2,
              )
            ],
            title: 'Edit description',
            cancelText: 'Cancel',
            submitText: 'Save',
            onlySaveOnSubmit: true,
          ),
          onPop: () => setState(() {}),
        ),
        PreferenceTitle('Content'),
        PreferenceDialogLink(
          'Content Types',
          dialog: PreferenceDialog(
            [
              CheckboxPreference('Text', 'content_show_text'),
              CheckboxPreference('Images', 'content_show_image'),
              CheckboxPreference('Music', 'content_show_audio')
            ],
            title: 'Enabled Content Types',
            cancelText: 'Cancel',
            submitText: 'Save',
            onlySaveOnSubmit: true,
          ),
        ),
        PreferenceTitle('More Dialogs'),
        PreferenceDialogLink(
          'Android\'s "ListPreference"',
          dialog: PreferenceDialog(
            [
              RadioPreference(
                  'Select me!', 'select_1', 'android_listpref_selected'),
              RadioPreference(
                  'Hello World!', 'select_2', 'android_listpref_selected'),
              RadioPreference('Test', 'select_3', 'android_listpref_selected'),
            ],
            title: 'Select an option',
            cancelText: 'Cancel',
            submitText: 'Save',
            onlySaveOnSubmit: true,
          ),
        ),
        PreferenceDialogLink(
          'Android\'s "ListPreference" with autosave',
          dialog: PreferenceDialog(
            [
              RadioPreference(
                  'Select me!', 'select_1', 'android_listpref_auto_selected'),
              RadioPreference(
                  'Hello World!', 'select_2', 'android_listpref_auto_selected'),
              RadioPreference(
                  'Test', 'select_3', 'android_listpref_auto_selected'),
            ],
            title: 'Select an option',
            cancelText: 'Close',
          ),
        ),
        PreferenceDialogLink(
          'Android\'s "MultiSelectListPreference"',
          dialog: PreferenceDialog(
            [
              CheckboxPreference('A enabled', 'android_multilistpref_a'),
              CheckboxPreference('B enabled', 'android_multilistpref_b'),
              CheckboxPreference('C enabled', 'android_multilistpref_c'),
            ],
            title: 'Select multiple options',
            cancelText: 'Cancel',
            submitText: 'Save',
            onlySaveOnSubmit: true,
          ),
        ),
        PreferenceHider([
          PreferenceTitle('Experimental'),
          SwitchPreference(
            'Show Operating System',
            'exp_showos',
            desc: 'This option shows the users operating system in his profile',
          )
        ], '!advanced_enabled'), // Use ! to get reversed boolean values
        PreferenceTitle('Advanced'),
        CheckboxPreference(
          'Enable Advanced Features',
          'advanced_enabled',
          onChange: () {
            setState(() {});
          },
          onDisable: () {
            PrefService.of(context).setBool('exp_showos', false);
          },
        )
      ]),
    );
  }
}
