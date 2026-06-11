import 'package:flutter/material.dart';
import '../localization/app_localization.dart';

class LanguageManager {
  static ValueNotifier<String> currentLanguage =
  ValueNotifier("en");

  static Future<void> changeLanguage(String code) async {
    currentLanguage.value = code;
    await AppLocalization.load(code);
  }
}