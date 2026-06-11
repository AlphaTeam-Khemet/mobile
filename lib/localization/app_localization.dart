import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalization {
  static Map<String, dynamic> _localizedStrings = {};

  static ValueNotifier<String> languageNotifier =
  ValueNotifier<String>('ar');

  static Future<void> load(String languageCode) async {
    String jsonString =
    await rootBundle.loadString(
      'assets/languages/$languageCode.json',
    );

    _localizedStrings = json.decode(jsonString);

    languageNotifier.value = languageCode;
  }

  static String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  static String get currentLanguage => languageNotifier.value;
}