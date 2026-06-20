import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dio_client.dart';

class ChatService {
  final Dio _dio = DioClient().dio;

  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final response = await _dio.get('/ai-guide/conversations');
      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      debugPrint('Error getting conversations: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getConversationMessages(String id) async {
    try {
      final response = await _dio.get('/ai-guide/conversations/$id/messages');
      return response.data;
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> askQuestion(String question, {String? conversationId, String? topic}) async {
    try {
      final data = {
        'question': question,
      };
      if (conversationId != null) data['conversation_id'] = conversationId;
      if (topic != null) data['topic'] = topic;

      final response = await _dio.post('/ai-guide/ask', data: data);
      return response.data;
    } catch (e) {
      debugPrint('Error asking question: $e');
      rethrow;
    }
  }

  Future<bool> updateConversationTitle(String id, String title) async {
    try {
      await _dio.patch('/ai-guide/conversations/$id/title', data: {'title': title});
      return true;
    } catch (e) {
      debugPrint('Error updating title: $e');
      return false;
    }
  }

  Future<bool> deleteConversation(String id) async {
    try {
      await _dio.delete('/ai-guide/conversations/$id');
      return true;
    } catch (e) {
      debugPrint('Error deleting conversation: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> describeMonument(String monumentName) async {
    try {
      final response = await _dio.post('/ai-guide/describe', data: {
        'monument_name': monumentName,
      });
      return response.data;
    } catch (e) {
      debugPrint('Error describing monument: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> identifyMonument(String monumentName, String question) async {
    try {
      final response = await _dio.post('/ai-guide/identify', data: {
        'monument_name': monumentName,
        'question': question,
      });
      return response.data;
    } catch (e) {
      debugPrint('Error identifying monument: $e');
      return null;
    }
  }
}
