import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import 'verification_code.dart';

import '../core/network/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _goToOtpPage(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService().forgotPassword(email);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VerificationCodePage(email: email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Failed to send OTP'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.of(context).size.height;
    final screenWidth =
        MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6DCCF),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
          ),

          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black87,
                ),
                onPressed: () =>
                    Navigator.pop(context),
              ),

              SizedBox(
                height: screenHeight * 0.02,
              ),

              Text(
                AppLocalization.translate(
                  "forgot_password",
                ),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                AppLocalization.translate(
                  "enter_your_email_address_to_receive_a_verification_code",
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.04,
              ),

              Center(
                child: ClipRRect(
                  borderRadius:
                  BorderRadius.circular(12),

                  child: Image.asset(
                    'assets/image/illustration_forgot_password_with_bg (1).png',
                    height:
                    screenHeight * 0.45,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.05,
              ),

              Text(
                AppLocalization.translate(
                  "email_address",
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(
                height: screenHeight * 0.01,
              ),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText:
                  AppLocalization.translate(
                    "example_khemet_com",
                  ),

                  filled: true,
                  fillColor: Colors.white,

                  border:
                  OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.04,
              ),

              SizedBox(
                width: double.infinity,
                height:
                screenHeight * 0.06,

                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _goToOtpPage(context),

                  style:
                  ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(
                      0xFFC9A24D,
                    ),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius
                          .circular(
                        12,
                      ),
                    ),
                  ),

                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(
                    AppLocalization.translate(
                      "send_code",
                    ),
                    style:
                    const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}