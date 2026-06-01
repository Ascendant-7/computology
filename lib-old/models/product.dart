class Product {
  const Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.category,
    this.originalPrice,
    this.description,
    this.images,
    this.specs,
    this.tags,
  });

  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final String category;

  // Optional
  final double? originalPrice;
  final String? description;
  final List<String>? images;
  final Map<String, String>? specs;
  final List<String>? tags;
}
