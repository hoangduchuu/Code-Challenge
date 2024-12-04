import 'package:code_challenge/models/photo_model.dart';
import 'package:code_challenge/presentation/widget/safe_network_image.dart';
import 'package:flutter/material.dart';

class PhotoItem extends StatelessWidget {
  final PhotoModel photo;

  const PhotoItem({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(8.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: SafeNetworkImage(
            imageUrl: photo.thumbnailUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          photo.title,
          style: theme.textTheme.titleMedium,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            'ID: ${photo.id}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}
