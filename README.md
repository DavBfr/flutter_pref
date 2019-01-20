# preferences

Create Preference Screens easily with advanced features and subpages

## Features

- Easy addition of preferences

- Subpages

- Customization options

- Hide preferences dynamically

- Reset state on Exception

## Installing

You should ensure that you add `preferences` as a dependency in your flutter project.

```yaml
dependencies:
  preferences: '^1.2.0'
```

Then run `flutter packages get` to get the package.

## Usage

Change your main method to
```dart
import 'package:preferences/preferences.dart';

main() async {
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}
```

And then you can use the widgets
```dart
return Scaffold(
      appBar: AppBar(
        title: Text('Preferences Demo'),
      ),
      body: PreferencePage([
        PreferenceTitle('General'),
        DropdownPreference(
          'Start Page',
          'start_page',
          defaultVal: 'Timeline',
          values: ['Posts', 'Timeline', 'Private Messages'],
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
      ]),
    );
```

Look at the example for more information.