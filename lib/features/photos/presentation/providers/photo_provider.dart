import 'package:flutter/cupertino.dart';

import '../../../../models/photo_model.dart';
import '../../data/repositories/photo_repository_impl.dart';

class PhotoProvider extends ChangeNotifier {
  final PhotoRepositoryImpl repository;

  List<PhotoModel> _photos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _limit = 10;

  // Load more when reaching 80% of current items
  final double _loadMoreThreshold = 0.8;

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
      print('Error loading photos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void handleScroll(ScrollController scrollController) {
    // Find the first visible item index
    if (!scrollController.hasClients) return;

    // Get the current first and last visible item indices
    final firstIndex = _getFirstVisibleItemIndex(scrollController);
    if (firstIndex == null) return;

    // Calculate the threshold for the current page
    final thresholdIndex = (_currentPage * _limit * _loadMoreThreshold).round();

    // If we've scrolled past the threshold index (8 for first page, 18 for second, etc.)
    if (firstIndex >= thresholdIndex && !_isLoading && _hasMore) {
      loadPhotos();
    }
  }

  int? _getFirstVisibleItemIndex(ScrollController scrollController) {
    if (!scrollController.hasClients) return null;

    const itemExtent = 76.0; // Approximate height of each ListTile + Card margin
    final currentScroll = scrollController.position.pixels;
    return (currentScroll / itemExtent).floor();
  }
}