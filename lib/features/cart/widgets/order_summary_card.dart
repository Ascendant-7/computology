import 'package:computology/core/widgets/primary_button.dart';
import 'package:computology/features/cart/widgets/summary_row.dart';
import 'package:flutter/material.dart';

class OrderSummaryCard extends StatelessWidget {
  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    this.onProceedToCheckout,
    this.checkoutLabel = 'Proceed to Checkout',
  });

  final String subtotal;
  final String shipping;
  final String tax;
  final String total;
  final VoidCallback? onProceedToCheckout;
  final String checkoutLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SummaryRow(label: 'Subtotal', value: subtotal),
                const SizedBox(height: 12),
                SummaryRow(label: 'Shipping', value: shipping),
                const SizedBox(height: 12),
                SummaryRow(label: 'Tax', value: tax),
                const Divider(height: 24),
                SummaryRow(
                  label: 'Total',
                  value: total,
                  isEmphasized: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          label: checkoutLabel,
          onPressed: onProceedToCheckout,
        ),
      ],
    );
  }
}