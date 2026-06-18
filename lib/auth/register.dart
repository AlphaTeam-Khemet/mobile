import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import 'signin.dart';
import '../shared_widgets/custom_text_field.dart';
import '../shared_widgets/password_strength_bar.dart';
import '../shared_widgets/custom_action_button.dart';
import '../core/network/auth_service.dart';
import '../main_tab_home/main_tab_home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _agreeToTerms = false;

  String _fullName = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _goToSignIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
  }

  double _calculateStrength(String password) {
    if (password.isEmpty) return 0;

    double strength = 0;

    if (password.length >= 6) strength += 0.3;

    if (RegExp(r'[A-Z]').hasMatch(password)) strength += 0.2;

    if (RegExp(r'[0-9]').hasMatch(password)) strength += 0.2;

    if (RegExp(r'[!@#\$&*~]').hasMatch(password)) strength += 0.3;

    return strength.clamp(0, 1);
  }

  Future<void> _handleRegister(BuildContext context) async {
    if (_isLoading) return;

    if (_fullName.isEmpty || _email.isEmpty || _password.isEmpty || _confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.translate("all_fields_are_required")), backgroundColor: Colors.red),
      );
      return;
    }
    if (_password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.translate("password_must_be_at_least_6_characters")), backgroundColor: Colors.red),
      );
      return;
    }
    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.translate("passwords_do_not_match")), backgroundColor: Colors.red),
      );
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.translate("you_must_agree_to_the_terms_privacy_policy")), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await _authService.register(fullName: _fullName, email: _email, password: _password);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.translate("account_created_successfully")), backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage(isGuest: false)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? "Registration failed"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    final screenWidth = MediaQuery.of(context).size.width;

    double strength = _calculateStrength(_password);

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
                    AppLocalization.translate("register"),

                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
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
                AppLocalization.translate("create_your_account"),
                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                     Text(
                        AppLocalization.translate("join_the_gem_smart_guide_experience"),
                      style: TextStyle(color: Colors.black54),
                    ),

                    SizedBox(height: screenHeight * 0.04),

                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.05),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),

                            blurRadius: 10,

                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Column(
                        children: [
                          CustomTextField(
                      label: AppLocalization.translate("full_name"),
                        hint: AppLocalization.translate("enter_your_full_name"),
                            onChanged: (val) => setState(() => _fullName = val),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          CustomTextField(
                              label: AppLocalization.translate("email_address"),
                              hint: AppLocalization.translate("enter_your_email"),

                            onChanged: (val) => setState(() => _email = val),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          CustomTextField(
                              label: AppLocalization.translate("password"),
                              hint: AppLocalization.translate("enter_your_password"),
                            obscure: _obscurePassword,

                            onChanged: (val) => setState(() => _password = val),

                            toggleVisibility: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          Align(
                            alignment: Alignment.centerLeft,

                            child: Text(
                              AppLocalization.translate("password_strength"),
                              style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          PasswordStrengthBar(strength: strength),

                          SizedBox(height: screenHeight * 0.025),

                          CustomTextField(
                              label: AppLocalization.translate("confirm_password"),
                              hint: AppLocalization.translate("re_enter_your_password"),

                            obscure: _obscureConfirmPassword,

                            onChanged: (val) =>
                                setState(() => _confirmPassword = val),

                            toggleVisibility: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Checkbox(
                                value: _agreeToTerms,

                                activeColor: const Color(0xFFC9A24D),

                                onChanged: (value) {
                                  setState(() {
                                    _agreeToTerms = value!;
                                  });
                                },
                              ),

                              Expanded(
                                child: RichText(
                                  text:  TextSpan(
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),

                                    children: [
                                      TextSpan(  text: AppLocalization.translate("i_agree_to_the"),
                                      ),

                                      TextSpan(
                                        text: AppLocalization.translate("terms_of_service"),

                                        style: TextStyle(
                                          color: Color(0xFFC9A24D),

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      TextSpan(  text: AppLocalization.translate("and"),
                                      ),

                                      TextSpan(
                                        text: AppLocalization.translate("privacy_policy"),

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

                          SizedBox(height: screenHeight * 0.03),

                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : CustomActionButton(
                              text: AppLocalization.translate("create_account"),
                            onTap: () => _handleRegister(context),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.03),

                    Center(
                      child: TextButton(
                        onPressed: () => _goToSignIn(context),

                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                            children:  [
                              TextSpan(
                                text: AppLocalization.translate("already_have_an_account"),

                                style: TextStyle(color: Colors.black),
                              ),

                              TextSpan(
                                text: AppLocalization.translate("sign_in"),

                                style: TextStyle(
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
