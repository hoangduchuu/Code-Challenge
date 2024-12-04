import 'package:code_challenge/presentation/screen/photos/provider/photo_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_data.dart';
import 'photo_unit_test.mocks.dart';

void main() {
  group('PhotoProvider Pagination Tests', () {
    late PhotoProvider photoProvider;
    late MockPhotoRepositoryImpl mockRepository;

    setUp(() {
      mockRepository = MockPhotoRepositoryImpl();
      photoProvider = PhotoProvider(repository: mockRepository);
    });

    test('should load first page correctly', () async {
      // Arrange
      final firstPagePhotos = PhotoMockData.generateMockPhotos(start: 0, count: 100);
      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async => firstPagePhotos);

      // Act
      await photoProvider.loadPhotos();

      // Assert
      expect(photoProvider.photos.length, 100);
      expect(photoProvider.hasMore, true);
      expect(photoProvider.isLoading, false);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
    });

    test('should load second page and append to existing photos', () async {
      // Arrange
      final firstPagePhotos = PhotoMockData.generateMockPhotos(start: 0, count: 100);
      final secondPagePhotos = PhotoMockData.generateMockPhotos(start: 100, count: 100);

      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async => firstPagePhotos);
      when(mockRepository.getPhotos(start: 100, limit: 100)).thenAnswer((_) async => secondPagePhotos);

      // Act
      await photoProvider.loadPhotos(); // Load first page
      await photoProvider.loadPhotos(); // Load second page

      // Assert
      expect(photoProvider.photos.length, 200);
      expect(photoProvider.hasMore, true);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
      verify(mockRepository.getPhotos(start: 100, limit: 100)).called(1);
    });

    test('should handle partial page correctly', () async {
      // Arrange
      final partialPagePhotos = PhotoMockData.generateMockPhotos(start: 0, count: 50);
      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async => partialPagePhotos);

      // Act
      await photoProvider.loadPhotos();

      // Assert
      expect(photoProvider.photos.length, 50);
      expect(photoProvider.hasMore, true);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
    });

    test('should handle empty page and set hasMore to false', () async {
      // Arrange
      final firstPagePhotos = PhotoMockData.generateMockPhotos(start: 0, count: 100);
      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async => firstPagePhotos);
      when(mockRepository.getPhotos(start: 100, limit: 100)).thenAnswer((_) async => []);

      // Act
      await photoProvider.loadPhotos(); // Load first page
      await photoProvider.loadPhotos(); // Load second page (empty)

      // Assert
      expect(photoProvider.photos.length, 100);
      expect(photoProvider.hasMore, false);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
      verify(mockRepository.getPhotos(start: 100, limit: 100)).called(1);
    });

    test('should not load more when hasMore is false', () async {
      // Arrange
      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async => []);

      // Act
      await photoProvider.loadPhotos(); // This will set hasMore to false
      await photoProvider.loadPhotos(); // This should not trigger another load

      // Assert
      expect(photoProvider.hasMore, false);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should refresh and clear existing data', () async {
      // Arrange
      final firstPagePhotos = PhotoMockData.generateMockPhotos(start: 0, count: 100);
      final refreshedPhotos = PhotoMockData.generateMockPhotos(start: 0, count: 50);

      int callCount = 0;
      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async {
        if (callCount == 0) {
          callCount++;
          return firstPagePhotos;
        } else {
          return refreshedPhotos;
        }
      });

      // Act
      await photoProvider.loadPhotos(); // Initial load
      await photoProvider.loadPhotos(refresh: true); // Refresh

      // Assert
      expect(photoProvider.photos.length, 50);
      expect(photoProvider.hasMore, true);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(2);
    });

    test('should handle concurrent requests correctly', () async {
      // Arrange
      final firstPagePhotos = PhotoMockData.generateMockPhotos(start: 0, count: 100);
      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async {
        return Future.delayed(
          const Duration(milliseconds: 100),
          () => firstPagePhotos,
        );
      });

      // Act - Trigger multiple loads simultaneously
      final futures = Future.wait([
        photoProvider.loadPhotos(),
        photoProvider.loadPhotos(),
        photoProvider.loadPhotos(),
      ]);

      await futures;

      // Assert - Should only make one API call
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
      expect(photoProvider.photos.length, 100);
    });

    test('should load sample data correctly', () async {
      // Arrange
      final samplePhotos = PhotoMockData.mockPhotoList;
      when(mockRepository.getPhotos(start: 0, limit: 100)).thenAnswer((_) async => samplePhotos);

      // Act
      await photoProvider.loadPhotos();

      // Assert
      expect(photoProvider.photos.length, 5);
      expect(photoProvider.photos.first.id, 6);
      expect(photoProvider.photos.last.id, 10);
      expect(photoProvider.hasMore, true);
      verify(mockRepository.getPhotos(start: 0, limit: 100)).called(1);
    });
  });
}
