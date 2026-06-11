import 'package:flutter/material.dart';

import '../localization/app_localization.dart';
import '../onboarding/onboarding1.dart';
import 'language.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        fit: StackFit.expand,

        children: [

          Image.asset(
            "assets/image/S.jpeg",
            fit: BoxFit.cover,
          ),

          Container(

            decoration: BoxDecoration(

              gradient: LinearGradient(

                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,

                colors: [

                  Colors.black.withOpacity(0.88),

                  Colors.black.withOpacity(0.78),

                  Colors.black.withOpacity(0.92),
                ],
              ),
            ),
          ),

          SafeArea(

            child: Padding(

              padding: const EdgeInsets.symmetric(
                horizontal: 22,
              ),

              child: Column(

                children: [

                  const SizedBox(height: 40),


                  Center(

                    child: Image.asset(

                      "assets/image/sp.png",

                      width:
                      MediaQuery.of(context).size.width * 1.15,

                      height: 340,

                      fit: BoxFit.fitWidth,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    AppLocalization.translate("your_journey_title"),

                    textAlign: TextAlign.center,

                    style: TextStyle(

                      color: Colors.white,
                      fontSize: 27,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,

                      shadows: [

                        Shadow(
                          blurRadius: 14,
                          color: Colors.black,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 130,),

                  SizedBox(

                    width: 290,
                    height: 62,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(

                        backgroundColor:
                        const Color(0xFFD4A844),

                        elevation: 14,

                        shadowColor: Colors.black,

                        shape: RoundedRectangleBorder(

                          borderRadius:
                          BorderRadius.circular(40),
                        ),
                      ),

                      onPressed: () {

                        Navigator.pushReplacement(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                            const LanguageScreen(),
                          ),
                        );
                      },

                      child:  Row(

                        mainAxisAlignment:
                        MainAxisAlignment.center,

                        children: [

                          Text(
                            AppLocalization.translate("enter_experience"),

                            style: TextStyle(

                              color: Colors.black,

                              fontSize: 20,

                              fontWeight: FontWeight.w800,
                            ),
                          ),

                          SizedBox(width: 10),

                          Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
