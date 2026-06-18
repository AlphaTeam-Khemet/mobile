import 'package:flutter/material.dart';
import '../auth/signin.dart';
import '../localization/app_localization.dart';
import '../shared_widgets/custom_text_field.dart';
import '../shared_widgets/custom_action_button.dart';

import '../core/network/auth_service.dart';

class CreateNewPasswordPage extends StatefulWidget {
  final String email;
  final String otp;
  const CreateNewPasswordPage({Key? key, required this.email, required this.otp}) : super(key: key);

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  double _strength = 0.0;

  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        _strength = 0.0;
      } else if (password.length < 6) {
        _strength = 0.25;
      } else if (password.length < 10) {
        _strength = 0.5;
      } else if (RegExp(r'(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~])')
          .hasMatch(password)) {
        _strength = 1.0;
      } else {
        _strength = 0.75;
      }
    });
  }

  Future<void> _savePassword(BuildContext context) async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
            AppLocalization.translate(
              "password_fields_cannot_be_empty",
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(
             AppLocalization.translate(
               "passwords_do_not_match",
             ),
           ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService().resetPassword(widget.email, widget.otp, newPassword);
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content: Text(
            AppLocalization.translate(
              "password_updated_successfully",
            ),
          ),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInPage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? 'Failed to reset password'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE6DCCF),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(height: screenHeight * 0.02),

              Center(
                child: ClipOval(
                  child: Image.asset(
                    'assets/image/send_email.png',
                    height: screenHeight * 0.28,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

               Center(
                child: Column(
                  children: [
                    Text(
                AppLocalization.translate("create_new_password"),                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      AppLocalization.translate(
                        "your_new_password_must_be_different_from_the_previous_one"),                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),

              CustomTextField(
                label: AppLocalization.translate("new_password"),
                hint: AppLocalization.translate("enter_your_new_password"),
                obscure: _obscureNewPassword,
                onChanged: _checkPasswordStrength,
                toggleVisibility: () =>
                    setState(() => _obscureNewPassword = !_obscureNewPassword),
              ),
              SizedBox(height: screenHeight * 0.013),

              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _strength,
                      backgroundColor: Colors.red.withOpacity(0.2),
                      color: _strength < 0.5
                          ? Colors.red
                          : _strength < 0.75
                          ? Colors.orange
                          : Colors.green,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Text(
                    _strength < 0.5
                        ? AppLocalization.translate("weak")
                        : _strength < 0.75
                        ? AppLocalization.translate("medium")
                        : AppLocalization.translate("strong"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.013),

              CustomTextField(
                label: AppLocalization.translate("confirm_password"),
                hint: AppLocalization.translate("repeat_your_new_password"),
                obscure: _obscureConfirmPassword,
                toggleVisibility: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              SizedBox(height: screenHeight * 0.05),

              _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Color(0xFFC9A24D)))
                  : CustomActionButton(
                text: AppLocalization.translate("save_password"),
                onTap: () => _savePassword(context),
              ),
              SizedBox(height: screenHeight * 0.02),

              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const SignInPage()),
                          (route) => false,
                    );
                  },
                  child: Text(
                    AppLocalization.translate("back_to_sign_in"),
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
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
