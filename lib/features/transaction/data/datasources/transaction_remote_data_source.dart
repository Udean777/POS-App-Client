import 'package:client/features/transaction/data/models/transaction_model.dart';
import 'package:client/features/transaction/domain/entities/cart_item_entity.dart';
import 'package:dio/dio.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionModel> processCheckout({
    required List<CartItemEntity> cartItems,
    required double amountPaid,
    required String paymentMethod,
  });
  Future<List<TransactionModel>> fetchTransactions();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio _dio;

  TransactionRemoteDataSourceImpl(this._dio);

  @override
  Future<TransactionModel> processCheckout({
    required List<CartItemEntity> cartItems,
    required double amountPaid,
    required String paymentMethod,
  }) async {
    final itemsPayload = cartItems.map((item) {
      return {
        "product_id": item.product.id,
        "variant_id": item.variant.id,
        "quantity": item.quantity,
      };
    }).toList();

    final response = await _dio.post(
      '/transactions',
      data: {
        "payment_method": paymentMethod,
        "amount_paid": amountPaid,
        "items": itemsPayload,
      },
    );

    return TransactionModel.fromJson(response.data['data']);
  }

  @override
  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await _dio.get('/transactions');
    final List list = response.data['data'] ?? [];
    return list.map((e) => TransactionModel.fromJson(e)).toList();
  }
}
