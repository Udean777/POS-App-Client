import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/features/transaction/domain/providers/transaction_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'transaction_list_provider.g.dart';

@riverpod
class TransactionList extends _$TransactionList {
  @override
  Future<List<TransactionEntity>> build() async {
    return _fetchTransactions();
  }

  Future<List<TransactionEntity>> _fetchTransactions() async {
    final repository = ref.read(transactionRepositoryProvider);
    final result = await repository.fetchTransactions();

    return result.fold(
      (error) => throw Exception(error.message),
      (transactions) => transactions,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchTransactions());
  }
}
