import 'dart:io';

import 'package:flutter/material.dart';
import '../auth/signin.dart';
import '../localization/app_localization.dart';
import '../onboarding/welcome.dart';
import '../shared_widgets/language_manager.dart';
import 'package:image_picker/image_picker.dart';
import '../core/network/user_service.dart';
import '../core/network/chat_service.dart';
import '../core/network/scan_service.dart';
import '../core/network/auth_service.dart';

class ProfilePage extends StatefulWidget {
  final bool isGuest;
  final int favoriteCount;

  const ProfilePage({
    Key? key,
    required this.favoriteCount, required this.isGuest,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEditing = false;
  bool isLoading = true;
  int _chatsCount = 0;
  int _scansCount = 0;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (widget.isGuest) {
      setState(() => isLoading = false);
      return;
    }
    final results = await Future.wait([
      UserService().getProfile(),
      ChatService().getConversations(),
      ScanService().getScanHistory(LanguageManager.currentLanguage.value),
    ]);

    final profileData = results[0] as Map<String, dynamic>?;
    final conversations = results[1] as List<Map<String, dynamic>>;
    final scanResult = results[2] as ScanResult;

    if (mounted) {
      setState(() {
        if (profileData != null) {
          fullNameController.text = profileData['full_name'] ?? '';
          emailController.text = profileData['email'] ?? '';
        }
        _chatsCount = conversations.length;
        final history = scanResult.data?['history'];
        _scansCount = (history is List) ? history.length : 0;
        isLoading = false;
      });
    }
  }


  final TextEditingController fullNameController =
      TextEditingController();

  final TextEditingController emailController =
      TextEditingController();


  final List<Map<String, String>> languages = [
    {"code": "en", "label": "🇬🇧 English"},
    {"code": "ar", "label": "🇪🇬 العربية"},
    {"code": "de", "label": "🇩🇪 Deutsch"},
    {"code": "ru", "label": "🇷🇺 Русский"},
    {"code": "fr", "label": "🇫🇷 Français"},
    {"code": "es", "label": "🇪🇸 Español"},
    {"code": "zh", "label": "🇨🇳 中文"},
  ];



  File? profileImage;

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {

      setState(() {
        profileImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {

    fullNameController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2E8D5),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFC9A24D)),
        ),
      );
    }

    return Scaffold(

      backgroundColor: const Color(0xFFF2E8D5),

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [



              Stack(

                alignment: Alignment.center,

                children: [

                   Center(

                    child: Text(
                      AppLocalization.translate("profile"),

                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),

                  Align(

                    alignment: Alignment.centerRight,

                    child: TextButton(

                      onPressed: () {

                        setState(() {
                          isEditing = !isEditing;
                        });
                      },

                      child: Text(

                          isEditing
                              ? AppLocalization.translate("done")
                              : AppLocalization.translate("edit"),
                        style: const TextStyle(
                          color: Color(0xFFC9A24D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),



              Center(

                child: Column(
                  children: [

                    GestureDetector(

                      onTap: isEditing
                          ? pickImage
                          : null,

                      child: Stack(

                        alignment:
                        Alignment.bottomRight,

                        children: [

                          Container(

                            width: 95,
                            height: 95,

                            decoration: BoxDecoration(

                              shape: BoxShape.circle,

                              color: const Color(0xFFC9A24D)
                                  .withOpacity(0.15),

                              image: DecorationImage(

                                fit: BoxFit.cover,

                                image: profileImage != null

                                    ? FileImage(profileImage!)
                                    : const AssetImage(
                                  "assets/image/profile.png",
                                ) as ImageProvider,
                              ),
                            ),
                          ),

                          if (isEditing)

                            Container(

                              padding:
                              const EdgeInsets.all(6),

                              decoration:
                              const BoxDecoration(
                                color: Color(0xFFC9A24D),
                                shape: BoxShape.circle,
                              ),

                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    isEditing

                        ? SizedBox(

                      width: 220,

                      child: TextField(

                        controller:
                        fullNameController,

                        textAlign: TextAlign.center,

                        decoration:
                        const InputDecoration(
                          border: InputBorder.none,
                        ),

                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight:
                          FontWeight.w800,
                          color: Colors.black87,
                        ),
                      ),
                    )

                        : Text(
                      fullNameController.text,

                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 4),

                     Text(
                      AppLocalization.translate("khemet_member"),
                      style: TextStyle(
                        fontSize: 13,
                        letterSpacing: 1.2,
                        color: Color(0xFFC9A24D),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),


              Container(

                padding: const EdgeInsets.all(16),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(18),

                  boxShadow: [

                    BoxShadow(
                      color:
                      Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                    ),
                  ],
                ),

                child: Column(
                  children: [

                    _buildInfoTile(
                      icon: Icons.person_outline,
                      title: AppLocalization.translate("full_name"),                      controller: fullNameController,
                    ),

                    const Divider(height: 24),

                    _buildInfoTile(
                      icon: Icons.email_outlined,
                      title: AppLocalization.translate("email"),                      controller: emailController,
                    ),

                    const Divider(height: 24),

                    Row(
                      children: [

                        Container(

                          padding:
                          const EdgeInsets.all(10),

                          decoration: BoxDecoration(
                            color:
                            const Color(0xFFC9A24D)
                                .withOpacity(0.12),

                            borderRadius:
                            BorderRadius.circular(12),
                          ),

                          child: const Icon(
                            Icons.language,
                            color: Color(0xFFC9A24D),
                            size: 20,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,

                            children: [

                               Text(
                          AppLocalization.translate("language"),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 4),

                              ValueListenableBuilder<String>(
                                valueListenable: LanguageManager.currentLanguage,
                                builder: (context, languageCode, child) {

                                  final safeLanguage = languages.any((l) => l['code'] == languageCode)
                                      ? languageCode
                                      : 'en';

                                  return isEditing
                                      ? DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: safeLanguage,
                                      isExpanded: true,

                                      items: languages.map((lang) {
                                        return DropdownMenuItem<String>(
                                          value: lang['code'],
                                          child: Text(lang['label']!),
                                        );
                                      }).toList(),

                                      onChanged: (value) async {
                                        if (value == null) return;

                                        await LanguageManager.changeLanguage(value);

                                        setState(() {});
                                      },
                                    ),
                                  )
                                      : Text(
                                    languages.firstWhere(
                                          (l) => l['code'] == languageCode,
                                      orElse: () => {"label": "🇬🇧 English"},
                                    )['label']!,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  );
                                },
                              ),





                              if (isEditing)

                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                        )],
                ),
              ]),



          ),
              if (isEditing)

                SizedBox(

                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(

                    style: ElevatedButton.styleFrom(

                      backgroundColor:
                      const Color(0xFFC9A24D),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                    ),

                    onPressed: () async {
                      if (widget.isGuest) {
                        setState(() {
                          isEditing = false;
                        });
                        return;
                      }

                      setState(() {
                        isLoading = true;
                      });

                      final success = await UserService().updateProfile(
                        fullName: fullNameController.text,
                        languageCode: LanguageManager.currentLanguage.value,
                      );

                      if (!mounted) return;
                      
                      setState(() {
                        isLoading = false;
                        isEditing = false;
                      });

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalization.translate("profile_updated")),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Failed to update profile. Please try again."),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },

                    child:  Text(
                      AppLocalization.translate("save_changes"),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 24),

              Container(

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                  BorderRadius.circular(22),
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                     Text(
                AppLocalization.translate("my_activity"),
                      style: TextStyle(
                        color: Color(0xFF9B7B42),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 14),

                     Text(
                      AppLocalization.translate("your_museum_journey"),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),


                    _buildActivityCard(
                      imagePath: "assets/icons/fav.png",
                      title: AppLocalization.translate("favorite_artifacts"),                      count: widget.favoriteCount.toString(),
                    ),

                    const SizedBox(height: 18),

                    _buildActivityCard(
                      imagePath: "assets/icons/chat.png",
                      title: AppLocalization.translate("ai_chat"),
                      count: _chatsCount.toString(),
                    ),

                    const SizedBox(height: 18),

                    _buildActivityCard(
                      imagePath: "assets/icons/scan.png",
                      title: AppLocalization.translate("uploaded_scans"),
                      count: _scansCount.toString(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),


              SizedBox(

                width: double.infinity,
                height: 55,

                child: ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(

                    backgroundColor: widget.isGuest
                        ? const Color(0xFFC9A24D)
                        : const Color(0xFF2E2925),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: () async {
                    if (widget.isGuest) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignInPage(),
                        ),
                      );
                    } else {
                      // Properly call logout: revoke server-side refresh token
                      // and clear both tokens from SharedPreferences.
                      await AuthService().logout();
                      if (!mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WelcomePage(),
                        ),
                        (route) => false,
                      );
                    }
                  },

                  icon: Icon(

                    widget.isGuest
                        ? Icons.login
                        : Icons.logout,

                    color: widget.isGuest
                        ? Colors.black
                        : const Color(0xFFC9A24D),
                  ),

                  label: Text(

                    widget.isGuest
                        ? AppLocalization.translate("sign_in")
                        : AppLocalization.translate("log_out"),

                    style: TextStyle(

                      color: widget.isGuest
                          ? Colors.black
                          : Colors.white,

                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInfoTile({

    required IconData icon,
    required String title,
    required TextEditingController controller,

  }) {

    return Row(
      children: [

        Container(

          padding: const EdgeInsets.all(10),

          decoration: BoxDecoration(
            color:
            const Color(0xFFC9A24D)
                .withOpacity(0.12),

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: Icon(
            icon,
            color: const Color(0xFFC9A24D),
            size: 20,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              Text(
                title,

                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              isEditing

                  ? TextField(
                controller: controller,

                decoration:
                const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                  EdgeInsets.zero,
                ),
              )

                  : Text(
                controller.text,

                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),

        Icon(
          isEditing
              ? Icons.edit
              : Icons.lock_outline,

          size: 18,
          color: Colors.grey,
        ),
      ],
    );
  }


  Widget _buildActivityCard({

    required String imagePath,
    required String title,
    required String count,

  }) {

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 26,
      ),

      decoration: BoxDecoration(

        color: const Color(0xFFF2E8D5),

        borderRadius:
        BorderRadius.circular(26),
      ),

      child: Row(
        children: [

          Image.asset(
            imagePath,

            width: 30,
            height: 30,

            fit: BoxFit.contain,
          ),

          const SizedBox(width: 20),

          Expanded(

            child: Text(
              title,

              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),

          Text(
            count,

            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFFA68B63),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}