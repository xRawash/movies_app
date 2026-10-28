import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static late SharedPreferences prefs;
  static Future<void> init() async{
    prefs = await SharedPreferences.getInstance();
  }
  static void finishedOnboarding (){
    prefs.setBool('finishedOnboarding', true);
  }
  static bool? getIsFinishedOnboarding () {
    return prefs.getBool('finishedOnboarding');
  }
}