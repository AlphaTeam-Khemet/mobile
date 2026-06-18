import 'dart:io';
import 'package:dio/dio.dart';
import 'dio_client.dart';

class ScanResult {
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  ScanResult({required this.success, this.errorMessage, this.data});
}

class ScanService {
  final Dio _dio = DioClient().dio;

  Future<ScanResult> scanArtifact(String imagePath, String languageCode) async {
    try {
      final file = await MultipartFile.fromFile(imagePath);
      final formData = FormData.fromMap({
        'image': file,
      });

      final response = await _dio.post(
        '/scan/artifact',
        data: formData,
        options: Options(
          headers: {'Accept-Language': languageCode},
        ),
      );
      
      return ScanResult(success: true, data: response.data);
    } on DioException catch (e) {
      return ScanResult(success: false, errorMessage: _extractError(e));
    } catch (e) {
      return ScanResult(success: false, errorMessage: e.toString());
    }
  }

  Future<ScanResult> translateHieroglyph(String imagePath, String languageCode) async {
    try {
      final file = await MultipartFile.fromFile(imagePath);
      final formData = FormData.fromMap({
        'image': file,
      });

      final response = await _dio.post(
        '/scan/translate',
        data: formData,
        options: Options(
          headers: {'Accept-Language': languageCode},
        ),
      );
      
      return ScanResult(success: true, data: response.data);
    } on DioException catch (e) {
      return ScanResult(success: false, errorMessage: _extractError(e));
    } catch (e) {
      return ScanResult(success: false, errorMessage: e.toString());
    }
  }

  Future<ScanResult> getScanHistory(String languageCode) async {
    try {
      final response = await _dio.get(
        '/scan/history',
        options: Options(
          headers: {'Accept-Language': languageCode},
        ),
      );
      return ScanResult(success: true, data: {'history': response.data});
    } on DioException catch (e) {
      return ScanResult(success: false, errorMessage: _extractError(e));
    } catch (e) {
      return ScanResult(success: false, errorMessage: e.toString());
    }
  }

  String _extractError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      if (e.response?.data is Map<String, dynamic>) {
        return e.response?.data['message'] ?? e.response?.data['error'] ?? 'Server error';
      }
    }
    return e.message ?? 'Network error occurred';
  }
}
