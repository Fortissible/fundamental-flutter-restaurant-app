import 'package:shared_preferences/shared_preferences.dart';

class SettingsSharedPreferences{
  static late SharedPreferences prefs;
  static const notifPrefsKey = "NOTIF_PREFS";

  static Future init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future setNotifPrefs(
      bool isToggled
      ) async {
    prefs.setBool(notifPrefsKey, isToggled);
  }

  static bool getNotifPrefs() {
    final isToggled = prefs.getBool(notifPrefsKey) ?? false;

    return isToggled;
  }
}