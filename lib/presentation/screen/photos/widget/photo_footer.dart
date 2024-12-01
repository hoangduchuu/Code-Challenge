import 'package:code_challenge/presentation/screen/photos/provider/photo_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoFooter extends StatelessWidget {
  const PhotoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhotoProvider>();
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0),
        child: provider.hasMore
            ? const CircularProgressIndicator()
            : Text(
                'No more photos',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
      ),
    );
  }
}
