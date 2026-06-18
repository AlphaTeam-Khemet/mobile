import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import 'onboarding1.dart';
import '../shared_widgets/language_manager.dart';
import '../shared_widgets/custom_language_dropdown.dart';
import '../widgets/app_colors.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _fadeAnimation;

  late Animation<Offset> _slideAnimation;

  @override
  void initState() {

    super.initState();

    _controller =
        AnimationController(

          vsync: this,

          duration: const Duration(seconds: 2),
        );

    _fadeAnimation =
        CurvedAnimation(

          parent: _controller,

          curve: Curves.easeIn,
        );

    _slideAnimation =
        Tween<Offset>(

          begin: const Offset(0, 0.3),

          end: Offset.zero,

        ).animate(

          CurvedAnimation(

            parent: _controller,

            curve: Curves.easeOut,
          ),
        );

    _controller.forward();
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  void _selectLanguage(BuildContext context, String lang) {
    LanguageManager.currentLanguage.value = lang;

    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Onboarding1()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight =
        MediaQuery.of(context).size.height;

    return Scaffold(

      body: Stack(

        children: [



          Container(

            decoration: BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topCenter,

                end: Alignment.bottomCenter,

                colors: [

                  Colors.black.withOpacity(0.98),

                  const Color(0xFF1A1208)
                      .withOpacity(0.92),

                  Colors.black.withOpacity(0.84),
                ],
              ),
            ),
          ),



          Positioned.fill(

            child: Opacity(

              opacity: 0.38,

              child: Image.asset(

                'assets/image/LANG.webp',

                fit: BoxFit.cover,
              ),
            ),
          ),

          SafeArea(

            child: FadeTransition(

              opacity: _fadeAnimation,

              child: SlideTransition(

                position: _slideAnimation,

                child: Column(

                  children: [

                    SizedBox(
                      height: screenHeight * 0.08,
                    ),

                    Image.asset(

                      'assets/image/Logo.png',

                      height: screenHeight * 0.28,

                      fit: BoxFit.fill,
                    ),

                    const SizedBox(height: 10),

                    Text(
                      AppLocalization.translate("grand_egyptian_museum"),

                      style: TextStyle(

                        fontSize: 24,

                        fontWeight: FontWeight.w600,

                        color: Colors.white,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      AppLocalization.translate("select_language"),

                      style: TextStyle(

                        fontSize: 22,

                        fontWeight: FontWeight.bold,

                        color: Colors.white,
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.03,
                    ),
                    Padding(

                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                      ),

                      child: CustomLanguageDropdown(

                        onSelect: (lang) =>
                            _selectLanguage(context, lang),
                      ),
                    ),

                    const Spacer(),

                    Text(
                      AppLocalization.translate("gem_2026"),
                      style: TextStyle(

                        color: Colors.white70,

                        fontSize: 14,
                      ),
                    ),

                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}