import 'package:flutter/material.dart';
import 'package:graduation_project/onboarding/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'GEM Smart Guide',

      debugShowCheckedModeBanner: false,

      theme: ThemeData(

        primarySwatch: Colors.blue,

        useMaterial3: true,
      ),


      home: const SplashScreen(),
    );
  }
}