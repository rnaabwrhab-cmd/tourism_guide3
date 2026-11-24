import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/attraction.dart';

/// Stores each user's favorites in:
/// users/{uid}/favorites/{attractionId}
class FavoritesService {
  FavoritesService._();
  static final FavoritesService instance = FavoritesService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _favorites {
    final user = _auth.currentUser;
    if (user == null) {
      throw StateError('No Firebase user is signed in.');
    }
    return _firestore.collection('users').doc(user.uid).collection('favorites');
  }

  String _idFor(Attraction attraction) =>
      attraction.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');

  Stream<List<Attraction>> watchFavorites() {
    return _favorites.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Attraction.fromMap(doc.data()))
        .toList());
  }

  Stream<bool> isFavorite(Attraction attraction) {
    return _favorites.doc(_idFor(attraction)).snapshots().map((doc) => doc.exists);
  }

  Future<void> toggleFavorite(Attraction attraction) async {
    final ref = _favorites.doc(_idFor(attraction));
    final doc = await ref.get();
    if (doc.exists) {
      await ref.delete();
    } else {
      await ref.set(attraction.toMap());
    }
  }
}
