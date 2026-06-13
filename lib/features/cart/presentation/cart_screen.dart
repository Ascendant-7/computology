import 'package:computology/core/utils/app_constants.dart';
import 'package:computology/core/utils/app_routes.dart';
import 'package:computology/core/widgets/section_header.dart';
import 'package:computology/features/cart/logic/cart_provider.dart';
import 'package:computology/features/cart/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.items.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => cart.clearCart(),
                child: const Text('Clear'),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.items.isEmpty) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CartHeaderBanner(
                    title: 'Your cart is empty',
                    message: 'Tap View Details on a product to start building a checkout flow.',
                    icon: Icons.shopping_cart_outlined,
                  ),
                  const SizedBox(height: 24),
                  EmptyCartState(
                    onBrowseProducts: onBrowseProducts,
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
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.pagePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CartHeaderBanner(
                  title: 'Ready to checkout',
                  message: 'You have ${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'} in your cart.',
                  icon: Icons.shopping_cart_outlined,
                ),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Cart items'),
                const SizedBox(height: 12),
                ...cart.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.product.imageUrl,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.product.name,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${item.product.price.toStringAsFixed(0)}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.updateQuantity(
                                  item.product.id,
                                  item.quantity - 1,
                                ),
                                iconSize: 20,
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.updateQuantity(
                                  item.product.id,
                                  item.quantity + 1,
                                ),
                                iconSize: 20,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => cart.removeProduct(item.product.id),
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                const SectionHeader(title: 'Order summary'),
                const SizedBox(height: 12),
                OrderSummaryCard(
                  subtotal: '\$${cart.total.toStringAsFixed(0)}',
                  shipping: '\$0',
                  tax: '\$0',
                  total: '\$${cart.total.toStringAsFixed(0)}',
                  onProceedToCheckout: () => Navigator.pushNamed(context, AppRoutes.checkout),
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
          );
        },
      ),
    );
  }
}
