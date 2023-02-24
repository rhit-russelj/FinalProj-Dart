import 'package:flutter/material.dart';
import 'package:final_proj_dart/models/prof.dart';

class ProfRow extends StatelessWidget {
  final Prof name;
  final Function() onTap;

  const ProfRow({
    required this.name,
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
              photo.imageUrl,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}