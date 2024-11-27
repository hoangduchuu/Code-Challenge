import 'package:code_challenge/models/photo_model.dart';


abstract class PhotoRepository {
  Future<List<PhotoModel>> getPhotos({required int start, required int limit});
}