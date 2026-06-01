import 'package:flutter/material.dart';
import 'signin.dart';
import '../shared_widgets/custom_text_field.dart';
import '../shared_widgets/password_strength_bar.dart';
import '../shared_widgets/custom_action_button.dart';

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

  void _createAccount(BuildContext context) {
    if (_fullName.isEmpty ||
        _email.isEmpty ||
        _password.isEmpty ||
        _confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All fields are required!"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (_password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters."),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (_password != _confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match!"),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must agree to the Terms & Privacy Policy."),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    _goToSignIn(context);
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
                    "Register",

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
                      "Create your account",

                      style: TextStyle(
                        fontSize: screenWidth * 0.07,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Join the GEM Smart Guide experience.",

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
                            label: "Full Name",

                            hint: "Enter your full name",

                            onChanged: (val) => setState(() => _fullName = val),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          CustomTextField(
                            label: "Email address",

                            hint: "example@mail.com",

                            onChanged: (val) => setState(() => _email = val),
                          ),

                          SizedBox(height: screenHeight * 0.025),

                          CustomTextField(
                            label: "Password",

                            hint: "Enter your password",

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
                              "Password Strength",

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
                            label: "Confirm Password",

                            hint: "Re-enter your password",

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
                                  text: const TextSpan(
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 14,
                                    ),

                                    children: [
                                      TextSpan(text: "I agree to the "),

                                      TextSpan(
                                        text: "Terms of Service",

                                        style: TextStyle(
                                          color: Color(0xFFC9A24D),

                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      TextSpan(text: " and "),

                                      TextSpan(
                                        text: "Privacy Policy.",

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

                          CustomActionButton(
                            text: "Create Account",

                            onTap: () => _createAccount(context),
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

                            children: const [
                              TextSpan(
                                text: "Already have an account? ",

                                style: TextStyle(color: Colors.black),
                              ),

                              TextSpan(
                                text: "Sign In",

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
