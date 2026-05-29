import 'package:flutter/material.dart';
import '../auth/signin.dart';
import '../shared_widgets/custom_text_field.dart';
import '../shared_widgets/custom_action_button.dart';

class CreateNewPasswordPage extends StatefulWidget {
  const CreateNewPasswordPage({Key? key}) : super(key: key);

  @override
  State<CreateNewPasswordPage> createState() => _CreateNewPasswordPageState();
}

class _CreateNewPasswordPageState extends State<CreateNewPasswordPage> {
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
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

  void _savePassword(BuildContext context) {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password fields cannot be empty."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Password updated successfully."),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignInPage()),
    );
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

              const Center(
                child: Column(
                  children: [
                    Text(
                      "CREATE NEW PASSWORD",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Your new password must be different from the previous one.",
                      style: TextStyle(
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
                label: "NEW PASSWORD",
                hint: "Enter your new password",
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
                        ? "WEAK"
                        : _strength < 0.75
                        ? "MEDIUM"
                        : "STRONG",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.013),

              CustomTextField(
                label: "CONFIRM PASSWORD",
                hint: "Repeat your new password",
                obscure: _obscureConfirmPassword,
                toggleVisibility: () => setState(
                        () => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              SizedBox(height: screenHeight * 0.05),

              CustomActionButton(
                text: "Save Password",
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
                  child: const Text(
                    "Back to Sign In",
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
