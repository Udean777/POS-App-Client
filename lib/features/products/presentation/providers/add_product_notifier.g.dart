// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddProduct)
final addProductProvider = AddProductProvider._();

final class AddProductProvider
    extends $NotifierProvider<AddProduct, AsyncValue<void>> {
  AddProductProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addProductProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addProductHash();

  @$internal
  @override
  AddProduct create() => AddProduct();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$addProductHash() => r'6f4bfee37a4dbd492017b7a83ed7392d74864a92';

abstract class _$AddProduct extends $Notifier<AsyncValue<void>> {
  AsyncValue<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, AsyncValue<void>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, AsyncValue<void>>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
