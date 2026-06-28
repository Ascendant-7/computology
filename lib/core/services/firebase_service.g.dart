// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseApp)
final firebaseAppProvider = FirebaseAppProvider._();

final class FirebaseAppProvider
    extends $FunctionalProvider<FirebaseApp, FirebaseApp, FirebaseApp>
    with $Provider<FirebaseApp> {
  FirebaseAppProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAppProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAppHash();

  @$internal
  @override
  $ProviderElement<FirebaseApp> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseApp create(Ref ref) {
    return firebaseApp(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseApp value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseApp>(value),
    );
  }
}

String _$firebaseAppHash() => r'b7827a7fc4e0b00711b53898f4ad62d64130cc38';
