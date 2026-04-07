// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_actions_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ProductActions)
final productActionsProvider = ProductActionsProvider._();

final class ProductActionsProvider
    extends $NotifierProvider<ProductActions, AsyncValue<void>> {
  ProductActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productActionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productActionsHash();

  @$internal
  @override
  ProductActions create() => ProductActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$productActionsHash() => r'c872239819e555983265d935532b2af078a60103';

abstract class _$ProductActions extends $Notifier<AsyncValue<void>> {
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
