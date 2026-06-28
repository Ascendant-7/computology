import 'package:computology/core/product/product.dart';
import 'package:computology/features/catalog/logic/favorites_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FavoritesProvider provider;

  final testProduct1 = const Product(
    id: 'p1',
    name: 'Test Laptop',
    imageUrl: 'https://example.com/img.png',
    price: 999.99,
    rating: 4.5,
    category: 'Laptops',
  );

  final testProduct2 = const Product(
    id: 'p2',
    name: 'Test Monitor',
    imageUrl: 'https://example.com/mon.png',
    price: 499.99,
    rating: 4.0,
    category: 'Monitors',
  );

  setUp(() {
    provider = FavoritesProvider();
  });

  group('FavoritesProvider', () {
    test('starts with empty favorites', () {
      expect(provider.favorites, isEmpty);
      expect(provider.count, equals(0));
    });

    test('toggleFavorite adds a product and returns true', () {
      final added = provider.toggleFavorite(testProduct1);

      expect(added, isTrue);
      expect(provider.count, equals(1));
      expect(provider.isFavorite('p1'), isTrue);
    });

    test('toggleFavorite removes an existing product and returns false', () {
      provider.toggleFavorite(testProduct1); // add
      final removed = provider.toggleFavorite(testProduct1); // remove

      expect(removed, isFalse);
      expect(provider.count, equals(0));
      expect(provider.isFavorite('p1'), isFalse);
    });

    test('isFavorite returns false for unknown product', () {
      expect(provider.isFavorite('unknown'), isFalse);
    });

    test('can add multiple products', () {
      provider.toggleFavorite(testProduct1);
      provider.toggleFavorite(testProduct2);

      expect(provider.count, equals(2));
      expect(provider.isFavorite('p1'), isTrue);
      expect(provider.isFavorite('p2'), isTrue);
    });

    test('removeFavorite removes by ID', () {
      provider.toggleFavorite(testProduct1);
      provider.toggleFavorite(testProduct2);

      provider.removeFavorite('p1');

      expect(provider.count, equals(1));
      expect(provider.isFavorite('p1'), isFalse);
      expect(provider.isFavorite('p2'), isTrue);
    });

    test('removeFavorite is no-op for unknown product', () {
      provider.toggleFavorite(testProduct1);
      provider.removeFavorite('unknown');

      expect(provider.count, equals(1));
    });

    test('clearFavorites removes all', () {
      provider.toggleFavorite(testProduct1);
      provider.toggleFavorite(testProduct2);

      provider.clearFavorites();

      expect(provider.favorites, isEmpty);
      expect(provider.count, equals(0));
    });

    test('favorites list is unmodifiable', () {
      provider.toggleFavorite(testProduct1);

      expect(
        () => provider.favorites.add(testProduct2),
        throwsUnsupportedError,
      );
    });

    test('notifies listeners on toggle', () {
      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.toggleFavorite(testProduct1); // add
      provider.toggleFavorite(testProduct1); // remove

      expect(notifyCount, equals(2));
    });

    test('notifies listeners on removeFavorite', () {
      provider.toggleFavorite(testProduct1);

      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.removeFavorite('p1');

      expect(notifyCount, equals(1));
    });

    test('notifies listeners on clearFavorites', () {
      provider.toggleFavorite(testProduct1);

      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      provider.clearFavorites();

      expect(notifyCount, equals(1));
    });
  });
}
