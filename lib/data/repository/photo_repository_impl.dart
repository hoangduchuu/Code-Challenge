import '../../domain/photo_repository.dart';
import '../../models/photo_model.dart';
import '../local/photo_remote_data_source.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoRemoteDataSource remoteDataSource;

  PhotoRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PhotoModel>> getPhotos({required int start, required int limit}) async {
    return await remoteDataSource.getPhotos(start: start, limit: limit);
  }
}
