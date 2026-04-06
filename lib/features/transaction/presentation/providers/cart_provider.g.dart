// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CartNotifier)
final cartProvider = CartNotifierProvider._();

final class CartNotifierProvider
    extends $NotifierProvider<CartNotifier, List<CartItemEntity>> {
  CartNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cartProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cartNotifierHash();

  @$internal
  @override
  CartNotifier create() => CartNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<CartItemEntity> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<CartItemEntity>>(value),
    );
  }
}

String _$cartNotifierHash() => r'b2e1d96b59b0fb0866a808d63f12f99d6825f909';

abstract class _$CartNotifier extends $Notifier<List<CartItemEntity>> {
  List<CartItemEntity> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<CartItemEntity>, List<CartItemEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<CartItemEntity>, List<CartItemEntity>>,
              List<CartItemEntity>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
