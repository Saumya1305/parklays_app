import 'package:flutter/material.dart';
import 'l10n/l10n.dart'; // ✅ Correct import for generated localization file

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  Locale get locale => _locale;

  void setLocale(Locale locale) {
    // ✅ Correct usage: supportedLocales is defined on S, not on S.delegate
    if (!S.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en');
    notifyListeners();
  }
}
