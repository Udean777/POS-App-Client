// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(StoreConfigNotifier)
final storeConfigProvider = StoreConfigNotifierProvider._();

final class StoreConfigNotifierProvider
    extends $NotifierProvider<StoreConfigNotifier, AsyncValue<void>> {
  StoreConfigNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storeConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storeConfigNotifierHash();

  @$internal
  @override
  StoreConfigNotifier create() => StoreConfigNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<void> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<void>>(value),
    );
  }
}

String _$storeConfigNotifierHash() =>
    r'070a8b8e44b76f946d2cd1bdb4f578f257016784';

abstract class _$StoreConfigNotifier extends $Notifier<AsyncValue<void>> {
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
