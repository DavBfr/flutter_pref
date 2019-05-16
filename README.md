# preferences

Create Preference Screens easily with advanced features and subpages

## Screenshots

<img src="https://gitlab.com/redsolver/preferences/raw/assets/Screenshot1.png"  width="120">
<img src="https://gitlab.com/redsolver/preferences/raw/assets/Screenshot2.png"  width="120">
<img src="https://gitlab.com/redsolver/preferences/raw/assets/Screenshot3.png"  width="120">

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
  preferences: ^3.0.0
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