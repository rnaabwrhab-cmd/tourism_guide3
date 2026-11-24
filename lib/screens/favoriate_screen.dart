import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../services/favorites_service.dart';
import '../widgets/attraction_card.dart';

class FavoriateScreen extends StatelessWidget {
  const FavoriateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FavoritesService.instance.watchFavorites(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Could not load favorites.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        final favorites = snapshot.data ?? [];
        if (favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('No favorites yet', style: TextStyle(fontSize: 18)),
                SizedBox(height: 6),
                Text('Tap the heart on a place to save it.'),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: favorites.length,
          itemBuilder: (context, index) =>
              AttractionCard(attraction: favorites[index]),
        );
      },
    );
  }
}
