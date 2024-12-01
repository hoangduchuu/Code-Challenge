import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SafeNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,

      placeholder: (context, url) => Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          //rounded
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        width: width,
        height: height,
      ),

      errorListener: (_) {
        // silent error
      },

      // Simple error widget with icon
      errorWidget: (context, url, error) => Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          //rounded
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        width: width,
        height: height,
        child: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
      ),
    );
  }
}
