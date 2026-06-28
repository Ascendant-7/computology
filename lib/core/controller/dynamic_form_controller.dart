import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dynamic_form_controller.g.dart';

@riverpod
class DynamicFormController extends _$DynamicFormController {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit(Map<String, dynamic> data, String collection) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await FirebaseFirestore.instance.collection(collection).add(data);
    });
  }
}
