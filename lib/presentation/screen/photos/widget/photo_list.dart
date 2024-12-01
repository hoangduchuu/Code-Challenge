import 'package:code_challenge/presentation/item/photo_item.dart';
import 'package:code_challenge/presentation/screen/photos/provider/photo_provider.dart';
import 'package:code_challenge/presentation/screen/photos/widget/photo_footer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotosList extends StatelessWidget {
  const PhotosList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PhotoProvider>(
      builder: (context, provider, _) {
        if (provider.photos.isEmpty && provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              if (!provider.isLoading && provider.hasMore) {
                provider.loadPhotos();
              }
            }
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () => provider.loadPhotos(refresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.photos.length + 1,
              itemBuilder: (context, index) {
                if (index >= provider.photos.length) {
                  return const PhotoFooter();
                }
                return PhotoItem(photo: provider.photos[index]);
              },
            ),
          ),
        );
      },
    );
  }
}
