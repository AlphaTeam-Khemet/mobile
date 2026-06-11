import 'package:flutter/material.dart';
import '../localization/app_localization.dart';
import '../shared_widgets/custom_action_button.dart';
import 'create_new_password.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({Key? key}) : super(key: key);

  @override
  State<VerificationCodePage> createState() =>
      _VerificationCodePageState();
}

class _VerificationCodePageState
    extends State<VerificationCodePage> {

  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  int _secondsRemaining = 59;

  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {

    Future.doWhile(() async {

      await Future.delayed(
        const Duration(seconds: 1),
      );

      if (_secondsRemaining > 0) {

        setState(() {
          _secondsRemaining--;
        });

        return true;

      } else {

        setState(() {
          _canResend = true;
        });

        return false;
      }
    });
  }

  void _verifyCode(BuildContext context) {

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
        const CreateNewPasswordPage(),
      ),
    );
  }

  void _resendCode() {

    setState(() {

      _secondsRemaining = 59;

      _canResend = false;
    });

    _startTimer();
  }

  @override
  Widget build(BuildContext context) {

    final screenHeight =
        MediaQuery.of(context).size.height;

    final screenWidth =
        MediaQuery.of(context).size.width;

    return Scaffold(

      backgroundColor:
      const Color(0xFFE6DCCF),

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

                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              SizedBox(
                height: screenHeight * 0.015,
              ),

               Center(

                child: Column(

                  children: [

                    Text(

                AppLocalization.translate("verification_code"),
                      style: TextStyle(

                        fontSize: 24,

                        fontWeight: FontWeight.bold,

                        color: Colors.black87,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                        AppLocalization.translate(
                          "enter_the_verification_code_sent_to_your_email",
                        ),
                      textAlign: TextAlign.center,

                      style: TextStyle(

                        fontSize: 15,

                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: screenHeight * 0.03,
              ),

              Center(

                child: ClipRRect(

                  borderRadius:
                  BorderRadius.circular(12),

                  child: Image.asset(

                    'assets/image/otp.png',

                    height: screenHeight * 0.32,

                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.04,
              ),

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,

                children: List.generate(6, (index) {

                  return SizedBox(

                    width: screenWidth * 0.12,

                    child: TextField(

                      controller:
                      _controllers[index],

                      textAlign: TextAlign.center,

                      keyboardType:
                      TextInputType.number,

                      maxLength: 1,

                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),

                      decoration: InputDecoration(

                        counterText: "",

                        filled: true,

                        fillColor: Colors.white,

                        contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 18,
                        ),

                        border: OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(12),

                          borderSide:
                          BorderSide.none,
                        ),
                      ),

                      onChanged: (value) {

                        if (value.isNotEmpty &&
                            index < 5) {

                          FocusScope.of(context)
                              .nextFocus();
                        }
                      },
                    ),
                  );
                }),
              ),

              SizedBox(
                height: screenHeight * 0.04,
              ),


              Center(

                child: Column(

                  children: [

                    GestureDetector(

                      onTap:
                      _canResend
                          ? _resendCode
                          : null,

                      child: Text(

                        AppLocalization.translate("resend_code"),
                        style: TextStyle(

                          fontSize: 18,

                          fontWeight:
                          FontWeight.bold,

                          color: _canResend

                              ? const Color(0xFFC9A24D)

                              : Colors.black54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(

                      _canResend

                          ? AppLocalization.translate("ready_to_resend")

                          : "00:${_secondsRemaining.toString().padLeft(2, '0')}",

                      style: const TextStyle(

                        fontSize: 14,

                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: screenHeight * 0.06,
              ),

              CustomActionButton(

                text: AppLocalization.translate("verify_code"),
                onTap: () =>
                    _verifyCode(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}