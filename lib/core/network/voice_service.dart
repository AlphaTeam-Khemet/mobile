import 'package:dio/dio.dart';
import 'dio_client.dart';

class VoiceService {
  final Dio _dio = DioClient().dio;

  Future<String?> generateNarration({
    required String artifactId,
    required String artifactName,
    required String artifactDescription,
    required String language,
  }) async {
    try {
      final response = await _dio.post(
        'voice/artifacts/$artifactId/narrate',
        data: {
          'language': language,
          'artifact_name': artifactName,
          'artifact_description': artifactDescription,
        },
      );

      if (response.data != null && response.data['data'] != null) {
        final audioUrl = response.data['data']['audio_url'];
        if (audioUrl != null) {
          final filename = audioUrl.toString().split('/').last;
          // Return the full backend URL that the device can reach
          return '${DioClient().dio.options.baseUrl}/voice/audio/$filename';
        }
      }
      return null;
    } catch (e) {
      print('Voice generation error: $e');
      throw e;
    }
  }
}
