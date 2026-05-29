import 'package:flutter/material.dart';
import '../forgot_password/forgot_password.dart';
import '../home/home_screen.dart';
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
    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()));
  }

  void _goToHome(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email and Password cannot be empty."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainNavigationPage(),
    ));
  }

  void _goToForgotPassword(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth  = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6DCCF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Text("Sign In", style: TextStyle(fontSize: screenWidth * 0.07, fontWeight: FontWeight.bold)),
                  const Spacer(flex: 2),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenHeight * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome back", style: TextStyle(fontSize: screenWidth * 0.08, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text("Sign in to continue your journey through history.", style: TextStyle(color: Colors.black54)),

                    SizedBox(height: screenHeight * 0.07),

                    Container(
                      padding: EdgeInsets.all(screenWidth * 0.06),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.8)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        children: [
                          CustomTextField(
                            label: "Email address",
                            hint: "Enter your email",
                            controller: _emailController,
                          ),
                          SizedBox(height: screenHeight * 0.035),

                          CustomTextField(
                            label: "Password",
                            hint: "Enter your password",
                            obscure: _obscurePassword,
                            toggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                            controller: _passwordController,
                          ),
                          SizedBox(height: screenHeight * 0.015),

                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => _goToForgotPassword(context),
                              child: const Text("Forgot password?", style: TextStyle(color: Color(0xFF8B6F4E))),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          CustomActionButton(text: "Sign In", onTap: () => _goToHome(context)),
                        ],
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.12),

                    CustomActionButton(text: "Continue as Guest", onTap: () => _goToHome(context), outlined: true),
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
                            children: const [
                              TextSpan(
                                text: "Don’t have an account? ",
                                style: TextStyle(color: Colors.black87),
                              ),
                              TextSpan(
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
                    )
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
