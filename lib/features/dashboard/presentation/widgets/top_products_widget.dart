import 'package:flutter/material.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:client/src/theme/app_theme.dart';

class TopProductsWidget extends StatelessWidget {
  final List<TransactionEntity> transactions;

  const TopProductsWidget({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    // Calculate top 3 products
    final productSales = <String, _ProductStats>{};

    for (var tx in transactions) {
      for (var item in tx.items) {
        final key = "${item.productName} - ${item.variantName}";
        if (!productSales.containsKey(key)) {
          productSales[key] = _ProductStats(
            name: item.productName,
            variant: item.variantName,
            quantity: 0,
            revenue: 0,
          );
        }
        final stats = productSales[key]!;
        productSales[key] = stats.copyWith(
          quantity: stats.quantity + item.quantity,
          revenue: stats.revenue + item.subtotal,
        );
      }
    }

    final sortedProducts = productSales.values.toList()
      ..sort((a, b) => b.quantity.compareTo(a.quantity));

    final top3 = sortedProducts.take(3).toList();

    if (top3.isEmpty) {
      return const SizedBox();
    }

    return AppCard(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Produk Terlaris",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Icon(Icons.trending_up, color: AppColors.success),
            ],
          ),
          const SizedBox(height: 24),
          ...top3.asMap().entries.map((entry) {
            final index = entry.key;
            final product = entry.value;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == top3.length - 1 ? 0 : 20,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryOpaque,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "#${index + 1}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: Theme.of(context).textTheme.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          product.variant,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${product.quantity} Terjual",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.toIDR(product.revenue),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ProductStats {
  final String name;
  final String variant;
  final int quantity;
  final double revenue;

  _ProductStats({
    required this.name,
    required this.variant,
    required this.quantity,
    required this.revenue,
  });

  _ProductStats copyWith({
    String? name,
    String? variant,
    int? quantity,
    double? revenue,
  }) {
    return _ProductStats(
      name: name ?? this.name,
      variant: variant ?? this.variant,
      quantity: quantity ?? this.quantity,
      revenue: revenue ?? this.revenue,
    );
  }
}
