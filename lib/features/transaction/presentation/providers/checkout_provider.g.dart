// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CheckoutNotifier)
final checkoutProvider = CheckoutNotifierProvider._();

final class CheckoutNotifierProvider
    extends
        $NotifierProvider<CheckoutNotifier, AsyncValue<TransactionEntity?>> {
  CheckoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'checkoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$checkoutNotifierHash();

  @$internal
  @override
  CheckoutNotifier create() => CheckoutNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<TransactionEntity?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<TransactionEntity?>>(
        value,
      ),
    );
  }
}

String _$checkoutNotifierHash() => r'ef19e70dec3f3203a59f5a9f69e55868a046f00d';

abstract class _$CheckoutNotifier
    extends $Notifier<AsyncValue<TransactionEntity?>> {
  AsyncValue<TransactionEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<TransactionEntity?>,
              AsyncValue<TransactionEntity?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<TransactionEntity?>,
                AsyncValue<TransactionEntity?>
              >,
              AsyncValue<TransactionEntity?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
