import 'package:shared_preferences/shared_preferences.dart';

class PrefService {
  static SharedPreferences sharedPreferences;

  static Future<bool> init() async {
    print('Init Preferences Plugin');
    if (sharedPreferences == null)
      sharedPreferences = await SharedPreferences.getInstance();
    return true;
  }

  static bool getBool(String key) => sharedPreferences.getBool(key);

  static setBool(String key, bool val) {
    sharedPreferences.setBool(key, val);
  }
}
