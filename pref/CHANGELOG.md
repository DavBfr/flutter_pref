# Changelog

## 2.7.0

- Update dependencies
- Fix flutter_lints 2.0 warnings
- Add custom actions to PrefDialog
- BasePrefService.set() only trigger event if the value changed
- Added support for storing string lists

## 2.6.0

- Add PrefCustom and a PrefColor example

## 2.5.0

- Add ProxyPrefService
- Use flutter_lints
- Actually update the state when a preference is changed
- Add PrefDisabler
- Add PrefChevron button
- Fix PrefSlider layout
- Add DevTools support
- Add adaptive property to Switch

## 2.4.0

- Option to align slider below the title and trailing for wider control [MrCsabaToth](https://github.com/MrCsabaToth)
- Add dialog onSubmit and onDismiss callbacks

## 2.3.0

- Setting a value to `null` will remove it from the backend service

## 2.2.0

- Log all messages through the logging package
- Fix PrefSlider font size

## 2.1.0

- Expose inputFormatters in PrefText [tsonnen](https://github.com/tsonnen)

## 2.0.2

- Fix: Get old value in onChange of PrefButtonGroup [Joker]

## 2.0.1

- Update Readme

## 2.0.0

- Update dependencies

## 2.0.0-nullsafety

- Opt-in null-safety
- ButtonGroup now use ToggleButtons
- Use new buttons Widgets

## 1.6.0

- Fix cached dialog
- Fix PrefText onChange not called
- Use a common class for cached prefs
- Print the PerfService type in logs
- Improve PrefChoice

## 1.5.0

- Add PrefChoice Widget

## 1.4.0

- Cache() copies the default values
- Add `listen` parameter to `PerfService.of()`
- Fix cached Page and Dialog
- Add more documentation

## 1.3.1

- Add stream example

## 1.3.0

- Implement Stream on key change
- Add PrefPage caching
- Remove text-decoration border to follow the theme

## 1.2.0

- Fix reversed for null Switch
- Add defaults to PrefServiceCache
- Fix PrefText having an invalid value
- Improve PrefDialogButton
- Remove useless code from PrefService
- Remove Page and Dialog fallback to shared_preferences
- Add unit tests
- Add PrefSlider

## 1.1.0

- Add `reversed` attributes to boolean widgets
- Improve dropdown layout
- Prevent crash if the values are not the right type
- Remove useless typed methods

## 1.0.0

- Initial version
