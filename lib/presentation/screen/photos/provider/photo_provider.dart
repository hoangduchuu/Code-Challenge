import 'package:code_challenge/data/repository/photo_repository_impl.dart';
import 'package:flutter/foundation.dart';

import '../../../../models/photo_model.dart';

class PhotoProvider extends ChangeNotifier {
  final PhotoRepositoryImpl repository;

  List<PhotoModel> _photos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _limit = 100;

  PhotoProvider({required this.repository});

  List<PhotoModel> get photos => _photos;

  bool get isLoading => _isLoading;

  bool get hasMore => _hasMore;

  Future<void> loadPhotos({bool refresh = false}) async {
    if (_isLoading || (!_hasMore && !refresh)) return;

    _isLoading = true;
    if (refresh) {
      _currentPage = 0;
      _photos = [];
      _hasMore = true;
    }
    notifyListeners();

    try {
      final newPhotos = await repository.getPhotos(
        start: _currentPage * _limit,
        limit: _limit,
      );

      if (newPhotos.isEmpty) {
        _hasMore = false;
      } else {
        _photos.addAll(newPhotos);
        _currentPage++;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading photos: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
