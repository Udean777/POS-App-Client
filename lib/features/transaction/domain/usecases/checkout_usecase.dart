import 'package:client/core/errors/failure.dart';
import 'package:client/features/transaction/domain/entities/cart_item_entity.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:fpdart/fpdart.dart';

class CheckoutUsecase {
  final TransactionRepository repository;

  CheckoutUsecase(this.repository);

  Future<Either<Failure, TransactionEntity>> execute({
    required List<CartItemEntity> cartItems,
    required double amountPaid,
    required String paymentMethod,
  }) async {
    if (cartItems.isEmpty) {
      return Left(Failure("Keranjang belanja kosong"));
    }

    final totalAmount = cartItems.fold(0.0, (total, item) => total + item.subtotal);
    if (amountPaid < totalAmount) {
      return Left(Failure("Uang yang dibayar kurang dari total tagihan"));
    }

    return await repository.processCheckout(
      cartItems: cartItems,
      amountPaid: amountPaid,
      paymentMethod: paymentMethod,
    );
  }
}
