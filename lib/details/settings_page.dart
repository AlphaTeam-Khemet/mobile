import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import '../shared_widgets/language_manager.dart';
import '../core/network/user_service.dart';
import 'package:url_launcher/url_launcher.dart';
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
    {"code": "fr", "label": "🇫🇷 Français"},
    {"code": "es", "label": "🇪🇸 Español"},
    {"code": "zh", "label": "🇨🇳 中文"},
  ];



  bool notificationsEnabled = true;
  String selectedTextSize = "Medium";
  String _displayName = '';  // loaded from backend

  @override
  void initState() {
    super.initState();
    _loadProfileName();
  }

  Future<void> _loadProfileName() async {
    final data = await UserService().getProfile();
    if (data != null && mounted) {
      setState(() => _displayName = data['full_name'] ?? '');
    }
  }
  Future<void> _openFacebook() async {
    final Uri url =
    Uri.parse('https://www.facebook.com/share/1EnoZDpBSH/');

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _openInstagram() async {
    final Uri url = Uri.parse(
      'https://www.instagram.com/khemet.e2026?igsh=MWZ3MGtrdGV0NW9oYQ==',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

  Future<void> _openYoutube() async {
    final Uri url = Uri.parse(
      'https://www.youtube.com/channel/UCmbki6HSM_gVFTnUcOHLhFg',
    );

    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }

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

                   Text(
                    AppLocalization.translate("settings"),
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

                      children:  [

                        Text(
                          _displayName.isNotEmpty
                              ? _displayName
                              : AppLocalization.translate("alpha_team"),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),

                        SizedBox(height: 4),

                        Text(
                            AppLocalization.translate("khemet_member"),
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

               Text(
                  AppLocalization.translate("general_preferences"),
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

                           Expanded(
                            child: Text(
                              AppLocalization.translate("current_language"),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: LanguageManager.currentLanguage.value,

                              items: languages.map((language) {
                                return DropdownMenuItem<String>(
                                  value: language["code"],
                                  child: Text(language["label"]!),
                                );
                              }).toList(),

                              onChanged: (value) async {
                                if (value == null) return;

                                await LanguageManager.changeLanguage(value);

                                setState(() {});
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

                           Expanded(
                            child: Text(
                              AppLocalization.translate("notifications"),
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

                               Text(
                                AppLocalization.translate("accessibility"),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),

                           Text(
                            AppLocalization.translate("text_size"),
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
                                  AppLocalization.translate("small"),
                                ),

                                _buildTextSizeButton(
                                  AppLocalization.translate("medium"),
                                ),

                                _buildTextSizeButton(
                                  AppLocalization.translate("large"),                                ),
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

                     Center(
                      child: Text(
                        AppLocalization.translate("large"),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                     Text(
                        AppLocalization.translate(
                          "keep_your_khemet_account_safe_never_share_your_private_information_password_or_v",
                        ),
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

                           Text(
                            AppLocalization.translate("delete_account"),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    GestureDetector(
                      onTap: _openFacebook,
                      child: _buildSocialIcon(Icons.facebook),
                    ),

                    const SizedBox(width: 16),

                    GestureDetector(
                      onTap: _openInstagram,
                      child: _buildSocialIcon(
                        Icons.camera_alt_outlined,
                      ),
                    ),

                    const SizedBox(width: 16),

                    GestureDetector(
                      onTap: _openYoutube,
                      child: _buildSocialIcon(
                        Icons.play_arrow,
                      ),
                    ),
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