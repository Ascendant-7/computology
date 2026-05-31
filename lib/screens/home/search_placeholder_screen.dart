import 'package:flutter/material.dart';

class SearchPlaceholderScreen extends StatelessWidget {
  const SearchPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Center(
        child: Text(
          'Search module will connect here.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
