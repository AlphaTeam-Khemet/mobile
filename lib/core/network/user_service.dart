import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_client.dart';

class UserService {
  final Dio _dio = DioClient().dio;

  static const Map<String, int> _languageIds = {
    'en': 1,
    'ar': 2,
    'de': 3,
    'fr': 4,
    'es': 5,
    'zh': 6,
  };

  static const Map<int, String> _idToLanguage = {
    1: 'en',
    2: 'ar',
    3: 'de',
    4: 'fr',
    5: 'es',
    6: 'zh',
  };

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final response = await _dio.get('/users/profile');
      final data = response.data;
      if (data['preferred_language'] != null && data['preferred_language'] is int) {
        data['language_code'] = _idToLanguage[data['preferred_language']] ?? 'en';
      }
      return data;
    } catch (e) {
      debugPrint('Error getting profile: $e');
      return null;
    }
  }

  Future<bool> updateProfile({required String fullName, required String languageCode}) async {
    try {
      final langId = _languageIds[languageCode] ?? 1;
      await _dio.put('/users/profile', data: {
        'full_name': fullName,
        'preferred_language': langId,
      });
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }
}
