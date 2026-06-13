import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:computology/core/utils/app_constants.dart';
import 'package:computology/core/widgets/primary_button.dart';
import 'package:computology/core/widgets/section_header.dart';
import 'package:computology/features/cart/logic/cart_provider.dart';
import 'package:computology/features/cart/widgets/summary_row.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: theme.colorScheme.primary),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    label: 'Go back',
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.12),
                          child: Icon(Icons.receipt_long, color: theme.colorScheme.onPrimaryContainer),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Review your order', style: theme.textTheme.titleLarge),
                              const SizedBox(height: 4),
                              Text(
                                '${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'} to confirm',
                                style: theme.textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Items'),
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
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.product.name, style: theme.textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text('Qty: ${item.quantity}', style: theme.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            Text(
                              '\$${(item.product.price * item.quantity).toStringAsFixed(0)}',
                              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 16),
                  const SectionHeader(title: 'Order summary'),
                  const SizedBox(height: 12),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SummaryRow(label: 'Subtotal', value: '\$${cart.total.toStringAsFixed(0)}'),
                          const SizedBox(height: 12),
                          SummaryRow(label: 'Shipping', value: '\$0'),
                          const SizedBox(height: 12),
                          SummaryRow(label: 'Tax', value: '\$0'),
                          const Divider(height: 24),
                          SummaryRow(label: 'Total', value: '\$${cart.total.toStringAsFixed(0)}', isEmphasized: true),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  PrimaryButton(
                    label: 'Place Order',
                    onPressed: () {
                      cart.clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Order placed successfully!'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
