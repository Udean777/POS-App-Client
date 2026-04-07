import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/features/transaction/domain/providers/transaction_providers.dart';
import 'package:client/features/transaction/presentation/providers/cart_provider.dart';
import 'package:client/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'checkout_provider.g.dart';

@riverpod
class CheckoutNotifier extends _$CheckoutNotifier {
  @override
  AsyncValue<TransactionEntity?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> processCheckout({
    required double amountPaid,
    required String paymentMethod,
    required Function(TransactionEntity) onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncValue.loading();
    final usecase = ref.read(checkoutUsecaseProvider);
    final cartItems = ref.read(cartProvider);

    final result = await usecase.execute(
      cartItems: cartItems,
      amountPaid: amountPaid,
      paymentMethod: paymentMethod,
    );

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        onError(failure.message);
      },
      (transaction) {
        state = AsyncValue.data(transaction);
        ref.read(cartProvider.notifier).clearCart();
        ref.read(productListProvider.notifier).refresh();
        ref.invalidate(transactionListProvider);

        onSuccess(transaction);
      },
    );
  }
}
