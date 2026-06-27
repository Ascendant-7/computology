import 'package:flutter/material.dart';

class EmptyCartState extends StatelessWidget {
  const EmptyCartState({
    super.key,
    required this.onBrowseProducts,
    this.title = 'Your cart is empty',
    this.message = 'Tap View Details on a product to start building a checkout flow.',
  });

  final VoidCallback onBrowseProducts;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onBrowseProducts,
              child: const Text('Browse products'),
            ),
          ],
        ),
      ),
    );
  }
}