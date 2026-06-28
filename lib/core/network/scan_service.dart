import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dio_client.dart';

class ScanResult {
  final bool success;
  final String? errorMessage;
  final Map<String, dynamic>? data;

  ScanResult({required this.success, this.errorMessage, this.data});
}

class ScanService {
  final Dio _dio = DioClient().dio;

  Future<String?> _compressImage(String imagePath) async {
    final file = File(imagePath);
    if (!file.existsSync()) return null;

    // Create a temporary path for the compressed image
    final lastIndex = imagePath.lastIndexOf(new RegExp(r'.jp|.png'));
    final splitted = imagePath.substring(0, (lastIndex == -1 ? imagePath.length : lastIndex));
    final outPath = "${splitted}_compressed.jpg";

    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path, 
      outPath,
      quality: 60, // Reduces file size considerably while preserving enough detail for YOLO/CLIP
      minWidth: 800, // Scales down huge 4K camera images
      minHeight: 800,
    );
    
    return result?.path;
  }

  Future<ScanResult> scanArtifact(String imagePath, String languageCode) async {
    try {
      final compressedPath = await _compressImage(imagePath) ?? imagePath;
      final file = await MultipartFile.fromFile(compressedPath);
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
      
      // Clean up the temporary compressed file
      if (compressedPath != imagePath) {
        File(compressedPath).delete().catchError((_) {});
      }

      return ScanResult(success: true, data: response.data);
    } on DioException catch (e) {
      return ScanResult(success: false, errorMessage: _extractError(e));
    } catch (e) {
      return ScanResult(success: false, errorMessage: e.toString());
    }
  }

  Future<ScanResult> translateHieroglyph(String imagePath, String languageCode) async {
    try {
      final compressedPath = await _compressImage(imagePath) ?? imagePath;
      final file = await MultipartFile.fromFile(compressedPath);
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
      
      // Clean up the temporary compressed file
      if (compressedPath != imagePath) {
        File(compressedPath).delete().catchError((_) {});
      }

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
