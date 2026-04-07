import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/features/transaction/domain/entities/transaction_item_entity.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TransactionItemCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionItemCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(colorScheme, textTheme),
          const SizedBox(height: 12),
          _buildMetaInfo(colorScheme, textTheme),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              color: AppColors.border,
            ),
          ),
          _buildItemsHeader(colorScheme, textTheme),
          const SizedBox(height: 12),
          ...transaction.items.map(
            (item) => _buildItemRow(item, colorScheme, textTheme),
          ),
          const SizedBox(height: 8),
          _buildSummarySection(colorScheme, textTheme),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryOpaque,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.receipt_outlined,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  "#${transaction.id.substring(0, 8).toUpperCase()}",
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            transaction.status,
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.info,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetaInfo(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              transaction.createdAt.toLocal().toString().split('.')[0],
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Container(width: 1, height: 14, color: AppColors.border),
          const SizedBox(width: 8),
          Icon(
            Icons.person_outline_rounded,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              transaction.staffEmail ?? "Unknown",
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Text(
          "Daftar Pembelian",
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryOpaque,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "${transaction.items.length} item",
            style: textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemRow(
    TransactionItemEntity item,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryOpaque,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${item.variantName} × ${item.quantity}",
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              CurrencyFormatter.toIDR(item.subtotal),
              textAlign: TextAlign.right,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primaryOpaque.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primaryOpaque),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            label: "Total Tagihan",
            value: CurrencyFormatter.toIDR(transaction.totalAmount),
            textTheme: textTheme,
            labelColor: colorScheme.onSurfaceVariant,
            valueColor: colorScheme.onSurface,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            label: "Jumlah Bayar",
            value: CurrencyFormatter.toIDR(transaction.amountPaid),
            textTheme: textTheme,
            labelColor: colorScheme.onSurfaceVariant,
            valueColor: colorScheme.onSurface,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Divider(
              height: 1,
              color: AppColors.primaryOpaque,
            ),
          ),
          _buildSummaryRow(
            label: "Kembalian",
            value: CurrencyFormatter.toIDR(transaction.change),
            textTheme: textTheme,
            labelColor: AppColors.textHeadline,
            valueColor: AppColors.primary,
            isBold: true,
            valueFontSize: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required String label,
    required String value,
    required TextTheme textTheme,
    required Color labelColor,
    required Color valueColor,
    bool isBold = false,
    double valueFontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: labelColor,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: valueFontSize,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
