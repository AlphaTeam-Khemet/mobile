import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {

  final int favoriteCount;

  const ProfilePage({
    Key? key,
    required this.favoriteCount,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {



  bool isEditing = false;


  final TextEditingController fullNameController =
  TextEditingController(text: "Alpha Team");

  final TextEditingController emailController =
  TextEditingController(text: "Alpha.Team@Gmail.com");


  final List<Map<String, String>> languages = [
    {"code": "en", "label": "🇬🇧 English"},
    {"code": "ar", "label": "🇪🇬 العربية"},
    {"code": "de", "label": "🇩🇪 Deutsch"},
    {"code": "ru", "label": "🇷🇺 Русский"},
  ];

  String selectedLanguage = "🇬🇧 English";



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

                  const Center(

                    child: Text(
                      "Profile",

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

                        isEditing ? "Done" : "Edit",

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

                    const Text(
                      "KHEMET MEMBER",

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
                      title: "FULL NAME",
                      controller: fullNameController,
                    ),

                    const Divider(height: 24),

                    _buildInfoTile(
                      icon: Icons.email_outlined,
                      title: "EMAIL",
                      controller: emailController,
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

                              const Text(
                                "LANGUAGE",

                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                  fontWeight:
                                  FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 4),

                              isEditing

                                  ? DropdownButtonHideUnderline(

                                child:
                                DropdownButton<String>(

                                  value:
                                  selectedLanguage,

                                  isExpanded: true,

                                  items: languages
                                      .map((lang) {

                                    return DropdownMenuItem(
                                      value:
                                      lang['label'],

                                      child: Text(
                                        lang['label']!,
                                      ),
                                    );
                                  }).toList(),

                                  onChanged: (value) {

                                    setState(() {
                                      selectedLanguage =
                                      value!;
                                    });
                                  },
                                ),
                              )

                                  : Text(
                                selectedLanguage,

                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                  FontWeight.w600,
                                  color:
                                  Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (isEditing)

                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),



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

                    onPressed: () {

                      setState(() {
                        isEditing = false;
                      });

                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                        const SnackBar(
                          content:
                          Text("Profile Updated"),
                        ),
                      );
                    },

                    child: const Text(
                      "Save Changes",

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

                    const Text(
                      "MY ACTIVITY",

                      style: TextStyle(
                        color: Color(0xFF9B7B42),
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Your Museum Journey",

                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 24),


                    _buildActivityCard(
                      imagePath: "assets/icons/fav.png",
                      title: "Favorite Artifacts",
                      count: widget.favoriteCount.toString(),
                    ),

                    const SizedBox(height: 18),

                    _buildActivityCard(
                      imagePath: "assets/icons/chat.png",
                      title: "AI Chat",
                      count: "0",
                    ),

                    const SizedBox(height: 18),

                    _buildActivityCard(
                      imagePath: "assets/icons/scan.png",
                      title: "Uploaded Scans",
                      count: "0",
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

                    backgroundColor:
                    const Color(0xFF2E2925),

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),
                  ),

                  onPressed: () {},

                  icon: const Icon(
                    Icons.logout,
                    color: Color(0xFFC9A24D),
                  ),

                  label: const Text(
                    "Log Out",

                    style: TextStyle(
                      color: Colors.white,
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