import 'package:flutter/material.dart';
import 'package:my_photo_bucket/models/video.dart';

class PhotoRow extends StatelessWidget {
  final Video photo;
  final Function() onTap;

  const PhotoRow({
    required this.photo,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.movie_creation_outlined),
            trailing: const Icon(Icons.chevron_right),
            title: Text(
              photo.caption,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              photo.videoUrl,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}