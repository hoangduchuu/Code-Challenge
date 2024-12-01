import 'package:code_challenge/features/photos/data/datasources/photo_remote_data_source.dart';
import 'package:code_challenge/features/photos/data/repositories/photo_repository_impl.dart';
import 'package:code_challenge/features/photos/presentation/providers/photo_provider.dart';
import 'package:code_challenge/models/photo_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'photo_unit_test.mocks.dart';

@GenerateMocks([PhotoRepositoryImpl, PhotoRemoteDataSource])
void main() {
  group('PhotoModel Tests', () {
    test('should create PhotoModel from JSON', () {
      // Arrange
      final json = {
        'albumId': 1,
        'id': 1,
        'title': 'Test Photo',
        'url': 'https://example.com/photo.jpg',
        'thumbnailUrl': 'https://example.com/thumbnail.jpg',
      };

      // Act
      final photo = PhotoModel.fromJson(json);

      // Assert
      expect(photo.albumId, 1);
      expect(photo.id, 1);
      expect(photo.title, 'Test Photo');
      expect(photo.url, 'https://example.com/photo.jpg');
      expect(photo.thumbnailUrl, 'https://example.com/thumbnail.jpg');
    });
  });

  group('PhotoProvider Tests', () {
    late PhotoProvider photoProvider;
    late MockPhotoRepositoryImpl mockRepository;

    setUp(() {
      mockRepository = MockPhotoRepositoryImpl();
      photoProvider = PhotoProvider(repository: mockRepository);
    });

    test('initial state should be empty', () {
      expect(photoProvider.photos, isEmpty);
      expect(photoProvider.isLoading, false);
      expect(photoProvider.hasMore, true);
    });

    test('loadPhotos should update state correctly', () async {
      // Arrange
      final mockPhotos = [
        PhotoModel(
          albumId: 1,
          id: 1,
          title: 'Test Photo 1',
          url: 'https://example.com/1.jpg',
          thumbnailUrl: 'https://example.com/thumb1.jpg',
        ),
      ];

      when(mockRepository.getPhotos(start: 0, limit: 100))
          .thenAnswer((_) async => mockPhotos);

      // Act
      await photoProvider.loadPhotos();

      // Assert
      expect(photoProvider.photos, mockPhotos);
      expect(photoProvider.isLoading, false);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
    });

    test('refresh should clear existing photos and load new ones', () async {
      // Arrange
      final mockPhotos = [
        PhotoModel(
          albumId: 1,
          id: 1,
          title: 'Test Photo 1',
          url: 'https://example.com/1.jpg',
          thumbnailUrl: 'https://example.com/thumb1.jpg',
        ),
      ];

      when(mockRepository.getPhotos(start: 0, limit: 100))
          .thenAnswer((_) async => mockPhotos);

      // Act
      await photoProvider.loadPhotos(refresh: true);

      // Assert
      expect(photoProvider.photos, mockPhotos);
      expect(photoProvider.isLoading, false);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
    });

    test('should handle empty response correctly', () async {
      // Arrange
      when(mockRepository.getPhotos(start: 0, limit: 100))
          .thenAnswer((_) async => []);

      // Act
      await photoProvider.loadPhotos();

      // Assert
      expect(photoProvider.photos, isEmpty);
      expect(photoProvider.hasMore, false);
      expect(photoProvider.isLoading, false);
    });

    test('should handle error correctly', () async {
      // Arrange
      when(mockRepository.getPhotos(start: 0, limit: 100))
          .thenThrow(Exception('Network error'));

      // Act
      await photoProvider.loadPhotos();

      // Assert
      expect(photoProvider.photos, isEmpty);
      expect(photoProvider.isLoading, false);
    });
  });
}