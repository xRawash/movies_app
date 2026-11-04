import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static late SharedPreferences prefs;
  static Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
  }
  static Future<void> finishedOnboarding () async {
    await prefs.setBool('finishedOnboarding', true);
  }
  static bool? getIsFinishedOnboarding () {
     return prefs.getBool('finishedOnboarding');
  }
  static Future<void> saveCurrentLang (String lang) async {
    await prefs.setString('currentLang', lang);
  }
  static String? getCurrentLang (){
    return prefs.getString('currentLang');
  }
}