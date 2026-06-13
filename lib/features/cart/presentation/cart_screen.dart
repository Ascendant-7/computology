import 'package:computology/core/utils/app_constants.dart';
import 'package:computology/core/widgets/section_header.dart';
import 'package:computology/features/cart/widgets/index.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    required this.onBrowseProducts,
    required this.onContinueShopping,
  });

  final VoidCallback onBrowseProducts;
  final VoidCallback onContinueShopping;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Clear'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CartHeaderBanner(
              title: 'Ready to checkout',
              message: 'Your selected items will appear here once you add them from Home.',
              icon: Icons.shopping_cart_outlined,
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Cart items'),
            const SizedBox(height: 12),
            EmptyCartState(
              onBrowseProducts: onBrowseProducts,
            ),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Order summary'),
            const SizedBox(height: 12),
            const OrderSummaryCard(
              subtotal: '\$0',
              shipping: '\$0',
              tax: '\$0',
              total: '\$0',
            ),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: onContinueShopping,
                child: const Text('Continue shopping'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
