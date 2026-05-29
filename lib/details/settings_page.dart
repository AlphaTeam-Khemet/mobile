import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {



  final List<Map<String, String>> languages = [
    {"code": "en", "label": "🇬🇧 English"},
    {"code": "ar", "label": "🇪🇬 العربية"},
    {"code": "de", "label": "🇩🇪 Deutsch"},
    {"code": "ru", "label": "🇷🇺 Русский"},
  ];

  String selectedLanguage = "🇬🇧 English";


  bool notificationsEnabled = true;

  String selectedTextSize = "Medium";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF2E8D5),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 14,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [


              Row(
                children: [



                  const SizedBox(width: 145,),

                  const Text(
                    "Settings",

                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(width: 20),
                ],
              ),

              const SizedBox(height: 24),


              Container(

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),

                  borderRadius: BorderRadius.circular(24),
                ),

                child: Row(
                  children: [


                    Container(
                      width: 62,
                      height: 62,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,

                        image: const DecorationImage(
                          image: AssetImage(
                            "assets/image/profile.png",
                          ),
                          fit: BoxFit.cover,
                        ),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),


                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: const [

                        Text(
                          "Alpha Team",

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                          "KHEMET Member",

                          style: TextStyle(
                            color: Color(0xFFC9A24D),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                "GENERAL PREFERENCES",

                style: TextStyle(
                  color: Color(0xFFA68B63),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              Container(

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(26),
                ),

                child: Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(18),

                      child: Row(
                        children: [

                          _buildIconBox(
                            Icons.language_rounded,
                          ),

                          const SizedBox(width: 16),

                          const Expanded(
                            child: Text(
                              "Current Language",

                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          DropdownButtonHideUnderline(

                            child: DropdownButton<String>(

                              value: selectedLanguage,

                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),

                              borderRadius:
                              BorderRadius.circular(16),

                              items: languages.map((language) {

                                return DropdownMenuItem(
                                  value: language["label"],

                                  child: Text(
                                    language["label"]!,
                                  ),
                                );
                              }).toList(),

                              onChanged: (value) {

                                setState(() {
                                  selectedLanguage = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                      color: Colors.grey,
                      height: 1,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(18),

                      child: Row(
                        children: [

                          _buildIconBox(
                            Icons.notifications_none_rounded,
                          ),

                          const SizedBox(width: 16),

                          const Expanded(
                            child: Text(
                              "Notifications",

                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Switch(

                            value: notificationsEnabled,

                            activeColor:
                            const Color(0xFFC9A24D),

                            onChanged: (value) {

                              setState(() {
                                notificationsEnabled =
                                    value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(18),

                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [

                          Row(
                            children: [

                              _buildIconBox(
                                Icons.accessibility_new_rounded,
                              ),

                              const SizedBox(width: 16),

                              const Text(
                                "Accessibility",

                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                          const Text(
                            "Text Size",

                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 14),

                          Container(

                            padding: const EdgeInsets.all(4),

                            decoration: BoxDecoration(
                              color: const Color(0xFFF2E8D5),

                              borderRadius:
                              BorderRadius.circular(18),
                            ),

                            child: Row(
                              children: [

                                _buildTextSizeButton(
                                  "Small",
                                ),

                                _buildTextSizeButton(
                                  "Medium",
                                ),

                                _buildTextSizeButton(
                                  "Large",
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Container(

                padding: const EdgeInsets.all(22),

                decoration: BoxDecoration(
                  color: Colors.white,

                  borderRadius: BorderRadius.circular(26),
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Container(

                      width: 48,
                      height: 48,

                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        color: const Color(0xFFC9A24D)
                            .withOpacity(0.12),

                        borderRadius:
                        BorderRadius.circular(14),
                      ),

                      child: Image.asset(
                        "assets/icons/Privacy.png",
                        fit: BoxFit.contain,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Center(
                      child: Text(
                        "Privacy & Security",

                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Keep your Khemet account safe Never share your private information, password, or verification codes with anyone.",

                      style: TextStyle(
                        color: Color(0xff6F6F6F),
                        height: 1.4,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 28),


                    Container(

                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),

                      decoration: BoxDecoration(
                        color: const Color(0xFFF2E8D5),

                        borderRadius:
                        BorderRadius.circular(16),
                      ),

                      child: Row(
                        children: [

                          Image.asset(
                            "assets/icons/delete.png",
                            width: 22,
                            height: 22,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(width: 12),

                          const Text(
                            "Delete account",

                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),



              Center(

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    _buildSocialIcon(Icons.facebook),

                    const SizedBox(width: 16),

                    _buildSocialIcon(
                      Icons.camera_alt_outlined,
                    ),

                    const SizedBox(width: 16),

                    _buildSocialIcon(Icons.play_arrow),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildIconBox(IconData icon) {

    return Container(

      width: 46,
      height: 46,

      decoration: BoxDecoration(

        color: const Color(0xFFF4EEE3),

        borderRadius: BorderRadius.circular(14),

        border: Border.all(
          color: const Color(0xFFE8DDCB),
          width: 1.2,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Center(

        child: Icon(
          icon,

          color: const Color(0xFF9B7B42),

          size: 22,
        ),
      ),
    );
  }


  Widget _buildTextSizeButton(String title) {

    final bool isSelected =
        selectedTextSize == title;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setState(() {
            selectedTextSize = title;
          });
        },

        child: Container(

          margin: const EdgeInsets.symmetric(
            horizontal: 3,
          ),

          padding: const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(

            color: isSelected
                ? const Color(0xFFC9A24D)
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(14),
          ),

          child: Center(

            child: Text(
              title,

              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : Colors.black87,

                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSocialIcon(IconData icon) {

    return Container(

      width: 48,
      height: 48,

      decoration: BoxDecoration(

        color: Colors.white,

        shape: BoxShape.circle,

        border: Border.all(
          color: Colors.grey.shade300,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),

      child: Icon(
        icon,
        color: Colors.grey.shade700,
        size: 24,
      ),
    );
  }
}