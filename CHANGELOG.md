## [5.0.0] - 03.10.2019

* Added validation for `TextFieldPreference`
* Added `obscureText`, `hintText`, `style`, `keyboardType`, `labelStyle` and `decoration` for `TextFieldPreference`
* Added `disabled` option for every widget
* Added `leading` and `subtitle` for `PreferenceText`

## [4.0.0] - 11.06.2019

* Added setDefaultValues function to PrefService
* CheckboxPreference, DropdownPreference, SwitchPreference, TextFieldPreference: Default value of the widget is now set and saved when first rendered
* Added possibility to modify saved text in TextFieldPreference by returning custom string in the onChange Method

## [3.0.0] - 06.05.2019

* Added TextField preference
* PreferenceTitle: Added Option to override left padding
* PreferenceDialogLink: Added onPop callback
* Fixed Prefix not applying when caching

## [2.0.0] - 30.01.2019

* Upgraded shared_preferences to 0.5.2

## [1.3.0] - 26.01.2019

* Fixed Issue with PrefService prefix not applying

## [1.2.0] - 20.01.2019

* Added PreferenceDialog and PreferenceDialogLink
* Added cache for PrefService to cache values and only apply them when submitting a dialog or confirming a change
* Added StringList Getter and Setter to PrefService
* Fixed some issues

## [1.1.0] - 17.01.2019

* Fixed Issue with default RadioPreference being not first

## [1.0.8] - 05.01.2019

* Fixed Issue with PreferenceHider

## [1.0.7] - 05.01.2019

* Fixed Issue with RadioPreference widgets on subpage

## [1.0.5] - 05.01.2019

* DropdownPreference Displayed Values can now be different from saved values
* PreferencePageLink Page Title can now be different from Link-Label

## [1.0.3] - 01.01.2019

* You can now init PrefService again with a different prefix

## [1.0.0] - 31.12.2018

* Initial release.
