import 'package:flutter/material.dart';
import 'package:computology/features/catalog/data/product.dart';

/// Manages the user's favorite (wishlist) products.
///
/// Follows the same [ChangeNotifier] pattern as [CartProvider].
class FavoritesProvider extends ChangeNotifier {
  final List<Product> _favorites = [];

  /// Unmodifiable view of the current favorites list.
  List<Product> get favorites => List.unmodifiable(_favorites);

  /// Number of favorited products.
  int get count => _favorites.length;

  /// Whether the given product is currently in favorites.
  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  /// Toggle a product in/out of favorites. Returns `true` if the product
  /// was added, `false` if it was removed.
  bool toggleFavorite(Product product) {
    final index = _favorites.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _favorites.removeAt(index);
      notifyListeners();
      return false;
    } else {
      _favorites.add(product);
      notifyListeners();
      return true;
    }
  }

  /// Remove a product by ID.
  void removeFavorite(String productId) {
    _favorites.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  /// Remove all favorites.
  void clearFavorites() {
    _favorites.clear();
    notifyListeners();
  }
}
