# pref

Create Preference Screens easily with advanced features and sub-pages

## Usage

In your main method, add:

```dart
WidgetsFlutterBinding.ensureInitialized();

final service = await PrefServiceShared.init(
  defaults: {
    'start_page': 'posts',
    'ui_theme': 'light',
  },
);

runApp(
  PrefService(
    service: service,
    child: MyApp(),
  ),
);
```

And then you can use the widgets

```dart
Scaffold(
  appBar: AppBar(
    title: Text('Preferences Demo'),
  ),
  body: PrefPage(children: [
    PrefTitle(title: Text('General')),
    PrefDropdown<String>(
      title: Text('Start Page'),
      pref: 'start_page',
      items: [
        DropdownMenuItem(value: 'posts', child: Text('Posts')),
        DropdownMenuItem(value: 'timeline', child: Text('Timeline')),
        DropdownMenuItem(value: 'pm', child: Text('Private Messages')),
      ],
    ),
    PrefTitle(title: Text('Personalization')),
    PrefRadio(
      title: Text('Light Theme'),
      value: 'light',
      pref: 'ui_theme',
    ),
    PrefRadio(
      title: Text('Dark Theme'),
      value: 'dark',
      pref: 'ui_theme',
    ),
  ]),
);
```

To use the values inside your application:

```dart
final startPage = PrefService.of(context).get('start_page');
```

Look at the example for more information.
