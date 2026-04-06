import 'package:client/core/providers/core_providers.dart';
import 'package:client/features/transaction/data/datasources/transaction_remote_data_source.dart';
import 'package:client/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:client/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:client/features/transaction/domain/usecases/checkout_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>((ref) {
      final dio = ref.watch(dioProvider);
      return TransactionRemoteDataSourceImpl(dio);
    });

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final remoteDataSource = ref.watch(transactionRemoteDataSourceProvider);
  return TransactionRepositoryImpl(remoteDataSource);
});

final checkoutUsecaseProvider = Provider((ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return CheckoutUsecase(repository);
});
