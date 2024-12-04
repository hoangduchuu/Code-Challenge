import 'package:code_challenge/models/photo_model.dart';

class PhotoMockData {
  static List<Map<String, dynamic>> get rawPhotoData => [
        {
          "albumId": 1,
          "id": 6,
          "title": "accusamus ea aliquid et amet sequi nemo",
          "url": "https://via.placeholder.com/600/56a8c2",
          "thumbnailUrl": "https://via.placeholder.com/150/56a8c2"
        },
        {
          "albumId": 1,
          "id": 7,
          "title": "officia delectus consequatur vero aut veniam explicabo molestias",
          "url": "https://via.placeholder.com/600/b0f7cc",
          "thumbnailUrl": "https://via.placeholder.com/150/b0f7cc"
        },
        {
          "albumId": 1,
          "id": 8,
          "title": "aut porro officiis laborum odit ea laudantium corporis",
          "url": "https://via.placeholder.com/600/54176f",
          "thumbnailUrl": "https://via.placeholder.com/150/54176f"
        },
        {
          "albumId": 1,
          "id": 9,
          "title": "qui eius qui autem sed",
          "url": "https://via.placeholder.com/600/51aa97",
          "thumbnailUrl": "https://via.placeholder.com/150/51aa97"
        },
        {
          "albumId": 1,
          "id": 10,
          "title": "beatae et provident et ut vel",
          "url": "https://via.placeholder.com/600/810b14",
          "thumbnailUrl": "https://via.placeholder.com/150/810b14"
        }
      ];

  // Get mock PhotoModel list from raw data
  static List<PhotoModel> get mockPhotoList => rawPhotoData.map((json) => PhotoModel.fromJson(json)).toList();

  // Generate mock photos for pagination testing
  static List<PhotoModel> generateMockPhotos({
    required int start,
    required int count,
    int albumId = 1,
  }) {
    return List.generate(
      count,
      (index) => PhotoModel(
        albumId: albumId,
        id: start + index + 1,
        title: 'Photo ${start + index + 1}',
        url: 'https://via.placeholder.com/600/${(start + index + 1).toString().padLeft(6, '0')}',
        thumbnailUrl: 'https://via.placeholder.com/150/${(start + index + 1).toString().padLeft(6, '0')}',
      ),
    );
  }

  // Get a single mock photo
  static PhotoModel getMockPhoto({
    required int id,
    int albumId = 1,
  }) {
    return PhotoModel(
      albumId: albumId,
      id: id,
      title: 'Photo $id',
      url: 'https://via.placeholder.com/600/${id.toString().padLeft(6, '0')}',
      thumbnailUrl: 'https://via.placeholder.com/150/${id.toString().padLeft(6, '0')}',
    );
  }
}
