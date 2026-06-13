import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImage = 0;

  List<String> get images => widget.product.images ?? [widget.product.imageUrl];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image card
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  images[_selectedImage],
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => const ColoredBox(
                    color: Colors.black12,
                    child: Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Thumbnails
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, idx) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedImage = idx),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 64,
                        height: 64,
                        color: Colors.black12,
                        child: Image.network(
                          images[idx],
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Tag
            if ((widget.product.tags ?? []).isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.product.tags!.first,
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.teal[800], fontWeight: FontWeight.w700),
                ),
              ),

            const SizedBox(height: 8),

            // Title
            Text(
              widget.product.name,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Short description
            if (widget.product.description != null)
              Text(widget.product.description!, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54)),

            const SizedBox(height: 12),

            // Price block
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${widget.product.price.toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(color: Colors.teal[800], fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                if (widget.product.originalPrice != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${widget.product.originalPrice!.toStringAsFixed(2)}', style: theme.textTheme.bodySmall?.copyWith(decoration: TextDecoration.lineThrough, color: Colors.black45)),
                      const SizedBox(height: 4),
                      Text('SPECIAL LAUNCH PRICE', style: theme.textTheme.labelSmall?.copyWith(color: Colors.teal[700], fontWeight: FontWeight.w600)),
                    ],
                  ),
              ],
            ),

            const SizedBox(height: 18),

            // Technical specs card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.list_alt_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text('Technical Specs', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...?widget.product.specs?.entries.map((e) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.key, style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54)),
                              Text(e.value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Actions
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                    label: const Text('Add to Cart'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[800], foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                    onPressed: () {
                      context.read<CartProvider>().addProduct(widget.product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Added to cart'),
                          duration: const Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'View Cart',
                            onPressed: () {
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {
                    // TODO: wishlist handling
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wishlist added')));
                  },
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: Colors.teal[800]!)),
                  child: const Icon(Icons.favorite_border, color: Colors.teal),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
