import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:computology/core/network/mock_data.dart';
import 'package:computology/core/utils/app_constants.dart';
import 'package:computology/core/utils/app_routes.dart';
import 'package:computology/core/widgets/banner_carousel.dart';
import 'package:computology/core/widgets/category_chip.dart';
import 'package:computology/core/widgets/product_card.dart';
import 'package:computology/core/widgets/section_header.dart';
import 'package:computology/features/catalog/data/category.dart';
import 'package:computology/features/catalog/data/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategoryId;

  List<Product> get _filteredProducts {
    if (_selectedCategoryId == null) return MockData.featuredProducts;
    return MockData.featuredProducts
        .where((p) => p.category.toLowerCase() == _selectedCategoryId!.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.memory,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Text('Computology', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () => context.go(AppRoutes.search)),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.pagePadding),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
            ),
            child: SizedBox(
              height: 42,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedCategoryId = null),
                    child: CategoryChip(
                      category: const Category(id: 'all', name: 'All', icon: Icons.grid_view),
                      isSelected: _selectedCategoryId == null,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ...MockData.categories.map((cat) => Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategoryId = cat.id),
                      child: CategoryChip(category: cat, isSelected: _selectedCategoryId == cat.id),
                    ),
                  )),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.pagePadding,
                vertical: 12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BannerCarousel(images: MockData.bannerImages),
                  const SizedBox(height: 24),
                  const SectionHeader(title: 'Featured Products'),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      if (constraints.maxWidth >= 900) {
                        crossAxisCount = 4;
                      } else if (constraints.maxWidth >= 600) {
                        crossAxisCount = 3;
                      }

                      final products = _filteredProducts;

                      if (products.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Text('No products in this category.',
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        );
                      }

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.62,
                        ),
                        itemBuilder: (context, index) {
                          return ProductCard(product: products[index]);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
