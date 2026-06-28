import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:computology/core/utils/app_constants.dart';
import 'package:computology/features/orders/data/order.dart';
import 'package:computology/features/orders/logic/order_provider.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orders = context.watch<OrderProvider>().orders;

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(height: 16),
                  Text('No orders yet', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Your placed orders will appear here.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.pagePadding),
              itemCount: orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(order: order);
              },
            ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final statusColor = switch (order.status) {
      OrderStatus.pending => Colors.orange,
      OrderStatus.processing => Colors.blue,
      OrderStatus.shipped => Colors.teal,
      OrderStatus.delivered => Colors.green,
    };

    final statusIcon = switch (order.status) {
      OrderStatus.pending => Icons.schedule,
      OrderStatus.processing => Icons.inventory_2,
      OrderStatus.shipped => Icons.local_shipping,
      OrderStatus.delivered => Icons.check_circle,
    };

    final dateStr =
        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}';

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.status.name.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text('\$${order.total.toStringAsFixed(0)}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Order #${order.id.substring(0, 8).toUpperCase()}',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text('$dateStr • ${order.paymentMethod}',
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text('${order.items.length} item${order.items.length == 1 ? '' : 's'}',
                style: theme.textTheme.bodyMedium),
            const Divider(height: 16),
            ...order.items.take(3).map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• ${item.product.name} x${item.quantity}',
                      style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                )),
            if (order.items.length > 3)
              Text('+${order.items.length - 3} more',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
