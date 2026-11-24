import 'package:flutter/material.dart';

import '../models/attraction.dart';
import '../services/favorites_service.dart';

class FavoriteButton extends StatelessWidget {
  final Attraction attraction;
  final double size;

  const FavoriteButton({
    super.key,
    required this.attraction,
    this.size = 26,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FavoritesService.instance.isFavorite(attraction),
      builder: (context, snapshot) {
        final isFavorite = snapshot.data ?? false;
        return IconButton(
          tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
            size: size,
          ),
          onPressed: () async {
            try {
              await FavoritesService.instance.toggleFavorite(attraction);
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not update favorites: $e')),
              );
            }
          },
        );
      },
    );
  }
}
