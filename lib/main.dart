import 'package:flutter/material.dart';
import 'package:graduation_project/onboarding/splashscreen.dart';
import 'package:graduation_project/localization/app_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLocalization.load('en');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: AppLocalization.languageNotifier,
      builder: (context, language, child) {
        return MaterialApp(
          title: 'KHEMET',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}