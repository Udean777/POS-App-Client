// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductListNotifier)
final productListProvider = ProductListNotifierProvider._();

final class ProductListNotifierProvider
    extends $AsyncNotifierProvider<ProductListNotifier, List<ProductEntity>> {
  ProductListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productListNotifierHash();

  @$internal
  @override
  ProductListNotifier create() => ProductListNotifier();
}

String _$productListNotifierHash() =>
    r'cc742a065d27776ff313c82abdddfae62e285ab1';

abstract class _$ProductListNotifier
    extends $AsyncNotifier<List<ProductEntity>> {
  FutureOr<List<ProductEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ProductEntity>>, List<ProductEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ProductEntity>>, List<ProductEntity>>,
              AsyncValue<List<ProductEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
