import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppLanguage {
  bangla,
  english,
}

extension AppLanguageExtension on AppLanguage {
  String get code => this == AppLanguage.bangla ? 'bn' : 'en';
  String get title => this == AppLanguage.bangla ? 'বাংলা' : 'English';
}

class LocaleProvider extends ChangeNotifier {
  AppLanguage _language = AppLanguage.bangla;

  AppLanguage get language => _language;
  bool get isBangla => _language == AppLanguage.bangla;
  bool get isEnglish => _language == AppLanguage.english;
  Locale get currentLocale => Locale(_language.code);

  void toggleLanguage() {
    _language = _language == AppLanguage.bangla ? AppLanguage.english : AppLanguage.bangla;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    HapticFeedback.selectionClick();
    notifyListeners();
  }

  /// Bilingual translation helper
  String tr(String bn, String en) => isBangla ? bn : en;
}
