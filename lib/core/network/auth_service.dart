import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_client.dart';

class AuthResult {
  final bool success;
  final String? errorMessage;
  AuthResult({required this.success, this.errorMessage});
}

class AuthService {
  final Dio _dio = DioClient().dio;

  static const Map<String, int> _languageIds = {
    'en': 1,
    'ar': 2,
    'de': 3,
    'fr': 4,
    'es': 5,
    'zh': 6,
  };

  Future<AuthResult> register({
    required String fullName,
    required String email,
    required String password,
    String preferredLanguage = 'en',
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'email': email,
        'password': password,
        'full_name': fullName,
        'preferred_language': _languageIds[preferredLanguage] ?? 1,
      });
      await _storeTokens(response.data);
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, errorMessage: _extractError(e));
    }
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      await _storeTokens(response.data);
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, errorMessage: _extractError(e));
    }
  }

  Future<AuthResult> forgotPassword(String email) async {
    try {
      await _dio.post('/auth/forgot-password', data: {'email': email});
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, errorMessage: _extractError(e));
    }
  }

  Future<AuthResult> verifyResetOtp(String email, String otp) async {
    try {
      await _dio.post('/auth/verify-reset-otp', data: {'email': email, 'otp': otp});
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, errorMessage: _extractError(e));
    }
  }

  Future<AuthResult> resetPassword(String email, String otp, String newPassword) async {
    try {
      await _dio.post('/auth/reset-password', data: {
        'email': email,
        'otp': otp,
        'new_password': newPassword,
      });
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, errorMessage: _extractError(e));
    }
  }

  Future<AuthResult> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      
      if (refreshToken == null) {
        return AuthResult(success: false, errorMessage: 'No refresh token available');
      }

      final response = await _dio.post('/auth/refresh', data: {
        'token': refreshToken,
      });
      await _storeTokens(response.data);
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, errorMessage: _extractError(e));
    }
  }

  Future<AuthResult> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString('refresh_token');
      
      if (refreshToken != null) {
        await _dio.post('/auth/logout', data: {
          'token': refreshToken,
        });
      }
      
      await prefs.remove('auth_token');
      await prefs.remove('refresh_token');
      
      return AuthResult(success: true);
    } on DioException catch (e) {
      return AuthResult(success: false, errorMessage: _extractError(e));
    }
  }

  Future<void> _storeTokens(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    if (data['access_token'] != null) {
      await prefs.setString('auth_token', data['access_token']);
    }
    if (data['refresh_token'] != null) {
      await prefs.setString('refresh_token', data['refresh_token']);
    }
  }

  String _extractError(DioException e) {
    final data = e.response?.data;
    if (data is Map && data['error'] != null) {
      return data['error'].toString();
    }
    return 'Something went wrong. Please check your connection and try again.';
  }
}
