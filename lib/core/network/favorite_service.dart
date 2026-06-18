import 'package:dio/dio.dart';
import 'dio_client.dart';

class FavoriteService {
  final Dio _dio = DioClient().dio;

  Future<List<Map<String, dynamic>>> getFavoriteRefs() async {
    final response = await _dio.get('/favorites');
    final List<dynamic> data = response.data;
    return data.map<Map<String, dynamic>>((f) => {
      'favoriteId': f['id'],
      'monumentId': f['monument_id'],
    }).toList();
  }

  Future<int> addFavorite(String monumentId) async {
    final response = await _dio.post('/favorites', data: {'monument_id': monumentId});
    return response.data['id'] as int;
  }

  Future<void> removeFavorite(int favoriteId) async {
    await _dio.delete('/favorites/$favoriteId');
  }
}
