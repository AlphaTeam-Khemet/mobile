import 'package:flutter/material.dart';
import '../localization/app_localization.dart';

class CustomLanguageDropdown extends StatefulWidget {
  final Function(String) onSelect;

  const CustomLanguageDropdown({
    Key? key,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<CustomLanguageDropdown> createState() =>
      _CustomLanguageDropdownState();
}

class _CustomLanguageDropdownState
    extends State<CustomLanguageDropdown> {
  String? selectedLanguage;

  final List<Map<String, String>> languages = [
    {"code": "en", "label": "🇬🇧 English"},
    {"code": "ar", "label": "🇪🇬 العربية"},
    {"code": "de", "label": "🇩🇪 Deutsch"},
    {"code": "ru", "label": "🇷🇺 Русский"},
    {"code": "fr", "label": "🇫🇷 Français"},
    {"code": "es", "label": "🇪🇸 Español"},
    {"code": "zh", "label": "🇨🇳 中文"},
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = AppLocalization.languageNotifier.value;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedLanguage,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      hint: Text(AppLocalization.translate("select_language")),
      items: languages.map((lang) {
        return DropdownMenuItem<String>(
          value: lang["code"],
          child: Text(lang["label"]!),
        );
      }).toList(),
      onChanged: (value) async {
        if (value == null) return;

        setState(() {
          selectedLanguage = value;
        });

        await AppLocalization.load(value);

        widget.onSelect(value);
      },
    );
  }
}