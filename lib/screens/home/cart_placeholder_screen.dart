import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';

class CartPlaceholderScreen extends StatelessWidget {
  const CartPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, _) {
          final items = cartProvider.items;
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Add products from the home screen', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                ],
              ),
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.broken_image, size: 40),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: Theme.of(context).textTheme.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('\$${item.product.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.teal[800])),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () => cartProvider.updateQuantity(item.product.id, item.quantity - 1),
                                      iconSize: 20,
                                    ),
                                    SizedBox(
                                      width: 30,
                                      child: Center(child: Text('${item.quantity}', style: Theme.of(context).textTheme.titleSmall)),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => cartProvider.updateQuantity(item.product.id, item.quantity + 1),
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => cartProvider.removeProduct(item.product.id),
                                  iconSize: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total:', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text('\$${cartProvider.total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.teal[800], fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[600], padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Proceeding to checkout...')));
                        // TODO: implement checkout
                      },
                      child: const Text('Checkout', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
