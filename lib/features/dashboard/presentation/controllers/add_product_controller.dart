// lib/features/dashboard/presentation/controllers/add_product_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:computology/core/product/product.dart';
import 'package:computology/core/services/firebase_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_product_controller.g.dart';

@riverpod
class AddProductController extends _$AddProductController {
  @override
  FutureOr<void> build() => const AsyncValue.data(null);

  Future<void> addProduct(Product product) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final app = ref.read(firebaseAppProvider);
      await FirebaseFirestore.instanceFor(
        app: app,
      ).collection('products').add(product.toMap());
    });
  }
}
