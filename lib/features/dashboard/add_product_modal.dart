import 'package:computology/core/product/product.dart';
import 'package:computology/core/widgets/app_modal_wrapper.dart';
import 'package:computology/core/widgets/app_text_field.dart';
import 'package:computology/core/widgets/form_container.dart';
import 'package:computology/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/controllers/add_product_controller.dart';

class AddProductModal extends ConsumerWidget {
  final List<Map<String, dynamic>> _fields = [
    {
      'key': 'name',
      'label': 'Product Name',
      'controller': TextEditingController(),
    },
    {'key': 'price', 'label': 'Price', 'controller': TextEditingController()},
    {
      'key': 'category',
      'label': 'Category',
      'controller': TextEditingController(),
    },
    {
      'key': 'imageUrl',
      'label': 'Image',
      'controller': TextEditingController(),
    },
  ];

  AddProductModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addProductControllerProvider);

    // event listening
    ref.listen(addProductControllerProvider, (previous, next) {
      // all operation finished
      if (previous?.isLoading == true && !next.isLoading) {
        if (next is AsyncData) {
          Navigator.of(context).pop();
        } else if (next is AsyncError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${next.error.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });

    return AppModalWrapper(
        child: FormContainer(
          children: [
            ..._fields.map(
              (field) => AppTextField(
                label: field['label']!,
                controller: field['controller']!,
              ),
            ),
            PrimaryButton(
              label: state.isLoading ? 'Adding...' : 'Add Product',
              onPressed: state.isLoading
                  ? null
                  : () {
                      final product = Product.fromMap({
                        for (var field in _fields)
                          field['key']!: field['controller'].text,
                      });
                      ref
                          .read(addProductControllerProvider.notifier)
                          .addProduct(product);
                    },
            ),
          ],
        ),
      );
  }
}
