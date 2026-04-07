import 'package:flutter/material.dart';

class TransactionEmptyView extends StatelessWidget {
  final VoidCallback onRefresh;

  const TransactionEmptyView({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 200),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 64,
                  color: colorScheme.onSurface.withValues(alpha: 0.15),
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada transaksi sama sekali.",
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
