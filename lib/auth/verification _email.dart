import 'package:flutter/material.dart';

import '../auth/register.dart';
import '../localization/app_localization.dart';
import '../main_tab_home/main_tab_home.dart';
import '../core/network/auth_service.dart';

class VerificationEmailPage extends StatefulWidget {
  final String email;

  const VerificationEmailPage({Key? key, required this.email})
    : super(key: key);

  @override
  State<VerificationEmailPage> createState() => _VerificationEmailPageState();
}

class _VerificationEmailPageState extends State<VerificationEmailPage> {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  bool isLoading = false;
  bool isResending = false;

  String get otp => otpControllers.map((e) => e.text).join();

  Future<void> verifyEmail() async {
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalization.translate("please_enter_the_6_digit_code"),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await AuthService().verifyEmail(otp);

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalization.translate("email_verified_successfully"),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigationPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? "Verification failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> resendCode() async {
    setState(() {
      isResending = true;
    });

    final result = await AuthService().resendEmailVerification();

    if (!mounted) return;

    setState(() {
      isResending = false;
    });

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalization.translate("verification_code_resent")),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? "Failed to resend code"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget otpField(int index) {
    return SizedBox(
      width: 48,
      child: TextFormField(
        controller: otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          }

          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8DED1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          child: Column(
            children: [
              SizedBox(height: height * 0.02),

              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
              ),

              SizedBox(height: height * 0.01),

              Text(
                AppLocalization.translate("verification_email"),
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: height * 0.03),

              Container(
                height: height * 0.35,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image.asset(
                    "assets/image/verification_email_improved.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),

              Text(
                AppLocalization.translate(
                  "enter_the_verification_code_sent_to_n_widget_email",
                ).replaceAll("\${widget.email}", widget.email),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15),
              ),

              SizedBox(height: height * 0.03),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => otpField(index)),
              ),

              SizedBox(height: height * 0.03),

              GestureDetector(
                onTap: isResending ? null : resendCode,
                child: isResending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFFC89B3C),
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        AppLocalization.translate("resend_code"),
                        style: TextStyle(
                          color: Color(0xFFC89B3C),
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),

              SizedBox(height: height * 0.04),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: isLoading ? null : verifyEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC89B3C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          AppLocalization.translate("verify_code"),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              SizedBox(height: height * 0.02),

              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterPage()),
                    (route) => false,
                  );
                },
                child: Text(
                  AppLocalization.translate("back_to_register"),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
