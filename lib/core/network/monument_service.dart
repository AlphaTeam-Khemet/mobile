import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_client.dart';
import 'api_config.dart';
import '../../shared_widgets/language_manager.dart';

class MonumentService {
  final Dio _dio = DioClient().dio;

  Future<List<Map<String, dynamic>>> getAllMonuments() async {
    try {
      final response = await _dio.get(
        '/monuments',
        queryParameters: {'lang': LanguageManager.currentLanguage.value},
      );

      final List<dynamic> data = response.data;

      return data.map<Map<String, dynamic>>((m) {
        final priorityRaw = m['priority']?.toString();
        final priorityValue = int.tryParse(priorityRaw ?? '') ?? 999999;

        final tags = <String>[];
        if (m['category'] != null && m['category'].toString().isNotEmpty) tags.add(m['category']);
        if (m['era'] != null && m['era'].toString().isNotEmpty) tags.add(m['era']);

        return {
          'id': m['id'],
          'title': m['name'] ?? 'Untitled Monument',
          'subtitle': m['era'] ?? m['category'] ?? '',
          'description': m['description'] ?? '',
          'image': ApiConfig.resolveImageUrl(m['cover_image']),
          'tags': tags,
          'category': m['category'],
          'priority': priorityValue,
        };
      }).toList();
    } catch (e) {
      debugPrint('Error fetching all monuments: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getMonumentById(String id) async {
    try {
      final response = await _dio.get(
        '/monuments/$id',
        queryParameters: {'lang': LanguageManager.currentLanguage.value},
      );
      
      final m = response.data;
      if (m == null) return null;

      final priorityRaw = m['priority']?.toString();
      final priorityValue = int.tryParse(priorityRaw ?? '') ?? 999999;

      final tags = <String>[];
      if (m['category'] != null && m['category'].toString().isNotEmpty) tags.add(m['category']);
      if (m['era'] != null && m['era'].toString().isNotEmpty) tags.add(m['era']);

      return {
        'id': m['id'],
        'title': m['name'] ?? 'Untitled Monument',
        'subtitle': m['era'] ?? m['category'] ?? '',
        'description': m['description'] ?? '',
        'image': ApiConfig.resolveImageUrl(m['cover_image']),
        'tags': tags,
        'category': m['category'],
        'priority': priorityValue,
      };
    } catch (e) {
      debugPrint('Error fetching monument $id: $e');
      return null;
    }
  }
}
