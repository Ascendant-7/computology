import 'package:flutter/material.dart';

class CartPlaceholderScreen extends StatelessWidget {
  const CartPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Center(
        child: Text(
          'Cart module will connect here.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
