import 'package:flutter/material.dart';
import 'package:movies_app/prefs_manager/prefs_manager.dart';

class ConfigProvider extends ChangeNotifier{
  String _language = PrefsManager.getCurrentLang() ?? 'en';
  String get language => _language;
  void setLanguage(String newLang){
    _language = newLang;
    PrefsManager.saveCurrentLang(newLang);
    notifyListeners();
  }
}