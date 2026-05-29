import 'package:flutter/material.dart';

class CustomLanguageDropdown extends StatefulWidget {
  final Function(String) onSelect;

  const CustomLanguageDropdown({Key? key, required this.onSelect})
      : super(key: key);

  @override
  State<CustomLanguageDropdown> createState() =>
      _CustomLanguageDropdownState();
}

class _CustomLanguageDropdownState extends State<CustomLanguageDropdown> {
  String? selectedLanguage;

  final List<Map<String, String>> languages = [
    {"code": "en", "label": "🇬🇧 English"},
    {"code": "ar", "label": "🇪🇬 العربية"},
    {"code": "de", "label": "🇩🇪 Deutsch"},
    {"code": "ru", "label": "🇷🇺 Русский"},
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedLanguage,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      hint: const Text("Select Language"),
      items: languages.map((lang) {
        return DropdownMenuItem<String>(
          value: lang["code"],
          child: Text(
            lang["label"]!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFFC9A24D),
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() => selectedLanguage = value);
        if (value != null) widget.onSelect(value);
      },
    );
  }
}
