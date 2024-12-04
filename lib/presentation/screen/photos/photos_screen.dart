import 'package:code_challenge/core/di/service_locator.dart';
import 'package:code_challenge/presentation/screen/photos/provider/photo_provider.dart';
import 'package:code_challenge/presentation/screen/photos/widget/photo_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return ChangeNotifierProvider(
      create: (_) => locator<PhotoProvider>()..loadPhotos(refresh: true),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          title: const Text('Photo Gallery'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh photos',
              onPressed: () => context.read<PhotoProvider>().loadPhotos(refresh: true),
            )
          ],
        ),
        body: const PhotosList(),
      ),
    );
  }
}
