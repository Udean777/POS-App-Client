import 'package:client/core/errors/failure.dart';
import 'package:client/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:client/features/transaction/data/models/transaction_model.dart';
import 'package:client/features/transaction/domain/entities/cart_item_entity.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, TransactionEntity>> processCheckout({
    required List<CartItemEntity> cartItems,
    required double amountPaid,
    required String paymentMethod,
  }) async {
    try {
      final model = await remoteDataSource.processCheckout(
        cartItems: cartItems,
        amountPaid: amountPaid,
        paymentMethod: paymentMethod,
      );
      return Right(model.toEntity());
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      String message = 'Gagal memproses transaksi';
      if (data is Map) {
        message = data['error'] ?? message;
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure('Koneksi bermasalah'));
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> fetchTransactions() async {
    try {
      final models = await remoteDataSource.fetchTransactions();
      return Right(models.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      String message = 'Gagal mengambil riwayat transaksi';
      if (data is Map) {
        message = data['error'] ?? message;
      }
      return Left(Failure(message));
    } catch (e) {
      return Left(Failure('Koneksi bermasalah'));
    }
  }
}
