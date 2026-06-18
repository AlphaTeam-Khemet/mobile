import 'package:flutter/material.dart';
import 'package:graduation_project/onboarding/splashscreen.dart';
import 'package:graduation_project/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project/main_tab_home/main_tab_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLocalization.load('en');

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final bool isLoggedIn = token != null && token.isNotEmpty;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  
  const MyApp({super.key, this.isLoggedIn = false});

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
          home: isLoggedIn 
              ? const MainNavigationPage(isGuest: false)
              : const SplashScreen(),
        );
      },
    );
  }
}