// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DynamicFormController)
final dynamicFormControllerProvider = DynamicFormControllerProvider._();

final class DynamicFormControllerProvider
    extends $NotifierProvider<DynamicFormController, AsyncValue<void>> {
  DynamicFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dynamicFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dynamicFormControllerHash();

  @$internal
  @override
  DynamicFormController create() => DynamicFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$dynamicFormControllerHash() =>
    r'6334154ff96598901222f93fe23e9f5a35ccdee6';

abstract class _$DynamicFormController extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
