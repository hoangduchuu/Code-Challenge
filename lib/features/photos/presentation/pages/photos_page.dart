import 'package:code_challenge/widget/safe_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/photo_provider.dart';

class PhotosPage extends StatefulWidget {
  const PhotosPage({super.key});

  @override
  createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PhotoProvider>().loadPhotos(refresh: true);
    });

    _scrollController.addListener(() {
      context.read<PhotoProvider>().handleScroll(_scrollController);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<PhotoProvider>().loadPhotos(refresh: true);
            },
          ),
        ],
      ),
      body: Consumer<PhotoProvider>(
        builder: (context, provider, child) {
          if (provider.photos.isEmpty && provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadPhotos(refresh: true),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: provider.photos.length + 1, // Always add 1 for the footer
              itemBuilder: (context, index) {
                if (index >= provider.photos.length) {
                  // Show loading indicator or end of data message
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: provider.hasMore
                          ? const CircularProgressIndicator()
                          : const Text(
                              'No more data',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  );
                }

                final photo = provider.photos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: SafeNetworkImage(
                      imageUrl: photo.thumbnailUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(photo.title),
                    subtitle: Text('ID: ${photo.id}'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
