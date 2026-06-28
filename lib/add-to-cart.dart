import 'package:computology/features/catalog/data/product.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, height: 200),
            SizedBox(height: 16),
            Text(product.name, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text('\$${product.price}', style: TextStyle(fontSize: 20, color: Colors.blue)),
            SizedBox(height: 8),
            Text('Rating: ${product.rating}'),
            SizedBox(height: 16),
            Text(product.description ?? 'No description available.'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
              child: Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}