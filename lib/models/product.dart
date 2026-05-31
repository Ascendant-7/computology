class Product {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.category,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final String category;
}
