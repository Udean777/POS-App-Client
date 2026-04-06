// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_product_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddProductNotifier)
final addProductProvider = AddProductNotifierProvider._();

final class AddProductNotifierProvider
    extends $NotifierProvider<AddProductNotifier, AsyncValue<void>> {
  AddProductNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$addProductNotifierHash();

  @$internal
  @override
  AddProductNotifier create() => AddProductNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$addProductNotifierHash() =>
    r'e381b3bc3799b0282ed77e3d6145fddf1cb507f9';

abstract class _$AddProductNotifier extends $Notifier<AsyncValue<void>> {
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
