import '../core/network/app_client.dart';
import '../models/photo_model.dart';

abstract class PhotoRemoteDataSource {
  Future<List<PhotoModel>> getPhotos({required int start, required int limit});
}

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final ApiClient apiClient;

  PhotoRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<PhotoModel>> getPhotos({required int start, required int limit}) async {
    final response = await apiClient.get(
      '/photos',
      queryParameters: {
        '_start': start,
        '_limit': limit,
      },
    );

    if (response.statusCode == 200) {
      return (response.data as List).map((json) => PhotoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
