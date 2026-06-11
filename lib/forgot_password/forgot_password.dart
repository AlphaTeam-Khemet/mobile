import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import 'verification_code.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  void _goToOtpPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VerificationCodePage(),
      ),
    );
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
                  onPressed: () =>
                      _goToOtpPage(context),

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

                  child: Text(
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