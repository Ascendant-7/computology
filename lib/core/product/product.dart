class Product {
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

  // constructors
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

  factory Product.fromFirestore(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name:
          data['name'] ??
          (throw Exception('missign field: name [fetched from firebase]')),
      price:
          (data['price'] as num?)?.toDouble() ??
          (throw Exception('missing field: price [fetched from firebase]')),
      imageUrl:
          data['imageUrl'] ??
          (throw Exception('missign field: imageUrl [fetched from firebase]')),
      category:
          data['category'] ??
          (throw Exception('missign field: category [fetched from firebase]')),
      rating:
          (data['rating'] as num?)?.toDouble() ??
          (throw Exception('missing field: rating [fetched from firebase]')),
    );
  }

  factory Product.fromMap(Map<String, String> data) {
    // onyl use for adding new product
    return Product(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: data['name']?.trim() ?? 'Unnamed Product',
      imageUrl: data['imageUrl'] ?? '',
      price: double.tryParse(data['price'] ?? '') ?? 0.0,
      rating: 0.0,
      category: data['category'] ?? '',
    );
  }

  // functions
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'rating': rating,
      'category': category,
      'description': description,
      'originalPrice': originalPrice,
      'tags': tags,
    };
  }
}
