import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:graduation_project/onboarding/splashscreen.dart';
import 'package:graduation_project/localization/app_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project/main_tab_home/main_tab_home.dart';
import 'package:graduation_project/core/network/auth_service.dart';

/// Decode the JWT payload and return the `exp` field as milliseconds since
/// epoch. Returns null if the token is malformed or has no exp claim.
int? _getJwtExpiry(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    // Base64Url decode with padding
    String payload = parts[1];
    payload += '=' * ((4 - payload.length % 4) % 4);
    final decoded = utf8.decode(base64Url.decode(payload));
    final data = json.decode(decoded) as Map<String, dynamic>;
    final exp = data['exp'];
    if (exp == null) return null;
    return (exp as int) * 1000; // convert seconds → milliseconds
  } catch (_) {
    return null;
  }
}

bool _isExpiredOrExpiringSoon(String token, {int bufferSeconds = 60}) {
  final expiry = _getJwtExpiry(token);
  if (expiry == null) return true;
  return DateTime.now().millisecondsSinceEpoch >= expiry - (bufferSeconds * 1000);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLocalization.load('en');

  final prefs = await SharedPreferences.getInstance();
  final storedToken = prefs.getString('auth_token');
  final storedRefresh = prefs.getString('refresh_token');

  bool isLoggedIn = false;

  if (storedToken != null && storedToken.isNotEmpty) {
    if (!_isExpiredOrExpiringSoon(storedToken)) {
      // Token still valid — proceed as logged in.
      isLoggedIn = true;
    } else if (storedRefresh != null && storedRefresh.isNotEmpty) {
      // Access token expired but refresh token exists — attempt silent refresh.
      final result = await AuthService().refreshToken();
      isLoggedIn = result.success;
      if (!result.success) {
        // Both tokens are dead — clear stale storage.
        await prefs.remove('auth_token');
        await prefs.remove('refresh_token');
      }
    } else {
      // No refresh token available — clear the stale access token.
      await prefs.remove('auth_token');
    }
  }

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