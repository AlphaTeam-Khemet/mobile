import 'package:flutter/material.dart';
import '../main_tab_home/main_tab_home.dart';
import 'onboarding1.dart';
import '../auth/signin.dart';
import '../auth/register.dart';
import '../shared_widgets/custom_action_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  void _goToSignIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
  }

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  void _goToOnboarding(BuildContext context) {
    Navigator.pushReplacement(
      context,

      MaterialPageRoute(
        builder: (_) => const MainNavigationPage(isGuest: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/image/welcome.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFE6DCCF).withOpacity(0.6),
                    const Color(0xFFE6DCCF),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    "Explore thousands of years of history with\n your personal AI guide. Translate hieroglyphs\n and uncover stories instantly.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 35),

                  CustomActionButton(
                    text: "Sign In",
                    onTap: () => _goToSignIn(context),
                  ),
                  const SizedBox(height: 16),

                  CustomActionButton(
                    text: "Continue as Guest",

                    onTap: () {
                      Navigator.pushReplacement(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const MainNavigationPage(isGuest: true),
                        ),
                      );
                    },

                    outlined: true,
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => _goToRegister(context),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          const TextSpan(
                            text: "Don’t have an account? ",
                            style: TextStyle(color: Colors.black87),
                          ),
                          const TextSpan(
                            text: "Register",
                            style: TextStyle(
                              color: Color(0xFFC9A24D),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
