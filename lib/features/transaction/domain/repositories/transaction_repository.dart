import 'package:client/core/errors/failure.dart';
import 'package:client/features/transaction/domain/entities/cart_item_entity.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class TransactionRepository {
  Future<Either<Failure, TransactionEntity>> processCheckout({
    required List<CartItemEntity> cartItems,
    required double amountPaid,
    required String paymentMethod,
  });

  Future<Either<Failure, List<TransactionEntity>>> fetchTransactions();
}
