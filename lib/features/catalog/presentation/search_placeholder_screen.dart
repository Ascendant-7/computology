import 'package:flutter/material.dart';

import 'package:computology/core/network/mock_data.dart';
import 'package:computology/features/catalog/data/product.dart';
import 'package:computology/core/widgets/product_card.dart';

class SearchPlaceholderScreen extends StatefulWidget {
  const SearchPlaceholderScreen({super.key});

  @override
  State<SearchPlaceholderScreen> createState() => _SearchPlaceholderScreenState();
}

class _SearchPlaceholderScreenState extends State<SearchPlaceholderScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  List<Product> get _allProducts => MockData.featuredProducts;

  List<Product> get _results {
    if (_query.trim().isEmpty) return _allProducts;
    final q = _query.toLowerCase();
    return _allProducts.where((p) {
      return p.name.toLowerCase().contains(q) || p.category.toLowerCase().contains(q) || (p.tags ?? []).any((t) => t.toLowerCase().contains(q));
    }).toList();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              height: 40,
              child: TextField(
                controller: _controller,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: 'Search products, categories... ',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: results.isEmpty
            ? Center(child: Text('No results found for "$_query"', style: Theme.of(context).textTheme.bodyMedium))
            : GridView.builder(
                itemCount: results.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  final product = results[index];
                  return ProductCard(product: product);
                },
              ),
      ),
    );
  }
}
