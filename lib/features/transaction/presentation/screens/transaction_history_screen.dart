import 'package:client/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:client/features/transaction/presentation/widgets/transaction_empty_view.dart';
import 'package:client/features/transaction/presentation/widgets/transaction_error_view.dart';
import 'package:client/features/transaction/presentation/widgets/transaction_item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionListProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(title: const Text("Riwayat Transaksi"), centerTitle: true),
      body: transactionState.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return TransactionEmptyView(
              onRefresh: () =>
                  ref.read(transactionListProvider.notifier).refresh(),
            );
          }

          return RefreshIndicator(
            color: colorScheme.primary,
            onRefresh: () async =>
                ref.read(transactionListProvider.notifier).refresh(),
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return TransactionItemCard(transaction: transactions[index]);
              },
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
        error: (err, stack) => TransactionErrorView(
          error: err.toString(),
          onRetry: () => ref.read(transactionListProvider.notifier).refresh(),
        ),
      ),
    );
  }
}
