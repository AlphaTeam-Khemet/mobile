import 'package:flutter/material.dart';
import 'welcome.dart';
import 'onboarding2.dart';
import 'onboarding3.dart';
import '../widgets/app_colors.dart';
import '../widgets/app_text_styles.dart';
import '../widgets/page_indicator.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_background.dart';

class Onboarding1 extends StatefulWidget {
  const Onboarding1({Key? key}) : super(key: key);

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  int currentIndex = 0;

  void _goToPage(int index) {
    setState(() => currentIndex = index);
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Onboarding1()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Onboarding2()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const Onboarding3()));
    }
  }

  void _nextPage() => _goToPage(1);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 150),
              child: const CustomBackground(
                imagePath: 'assets/image/Sub_Onboarding_1.png',
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: 20,
            child: TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WelcomePage()),
              ),
              child: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.35,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: const [
                            Text(
                              "🏛 SMART GUIDE",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 14),
                            Text(
                              "Explore the museum freely",
                              style: AppTextStyles.title,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Navigate the halls of history at your own pace with our intelligent digital companion.",
                              style: AppTextStyles.body,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PageIndicator(
                          count: 3,
                          currentIndex: currentIndex,
                          onTap: _goToPage,
                        ),
                        CustomButton(text: "", onTap: _nextPage),
                      ],
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
