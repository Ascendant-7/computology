import 'package:computology/features/cart/data/cart_item.dart';

enum OrderStatus { pending, processing, shipped, delivered }

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
  });

  Order copyWith({OrderStatus? status}) {
    return Order(
      id: id,
      items: items,
      total: total,
      paymentMethod: paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}
