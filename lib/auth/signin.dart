import 'package:flutter/material.dart';
import '../forgot_password/forgot_password.dart';
import '../localization/app_localization.dart';
import '../main_tab_home/main_tab_home.dart';
import '../shared_widgets/custom_text_field.dart';
import 'register.dart';
import '../shared_widgets/custom_action_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _goToRegister(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterPage()),
    );
  }

  void _goToHome(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.translate("email_and_password_cannot_be_empty")),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainNavigationPage(isGuest: false),
      ),
    );
  }

  void _goToForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6DCCF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04,
                vertical: screenHeight * 0.02,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text(
                    AppLocalization.translate("sign_in"),
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalization.translate("welcome_back"),
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      AppLocalization.translate(
                          "sign_in_to_continue_your_journey_through_history"),
                      style: const TextStyle(color: Colors.black54),
                    ),

                    SizedBox(height: screenHeight * 0.07),

                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            label: AppLocalization.translate("email_address"),
                            hint: AppLocalization.translate("enter_your_email"),
                            controller: _emailController,
                          ),

                          SizedBox(height: screenHeight * 0.035),

                          CustomTextField(
                            label: AppLocalization.translate("password"),
                            hint: AppLocalization.translate("enter_your_password"),
                            obscure: _obscurePassword,
                            toggleVisibility: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                            ),
                            controller: _passwordController,
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _goToForgotPassword(context),
                              child: Text(
                                AppLocalization.translate("forgot_password"),
                                style: const TextStyle(
                                  color: Color(0xFF8B6F4E),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          CustomActionButton(
                            text: AppLocalization.translate("sign_in"),
                            onTap: () => _goToHome(context),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.12),

                    CustomActionButton(
                      text: AppLocalization.translate("continue_as_guest"),
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

                    const SizedBox(height: 10),

                    Center(
                      child: TextButton(
                        onPressed: () => _goToRegister(context),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: AppLocalization.translate(
                                    "don_t_have_an_account"),
                                style: const TextStyle(color: Colors.black87),
                              ),
                              TextSpan(
                                text: " ${AppLocalization.translate("register")}",
                                style: const TextStyle(
                                  color: Color(0xFFC9A24D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}