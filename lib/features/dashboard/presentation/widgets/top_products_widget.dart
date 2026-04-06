import 'package:flutter/material.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/core/utils/currency_formatter.dart';

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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Produk Terlaris",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.trending_up,
                color: const Color(0xFF10B981).withOpacity(0.5),
              ),
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
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "#${index + 1}",
                        style: const TextStyle(
                          color: Color(0xFF6366F1),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          product.variant,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${product.quantity} Terjual",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.toIDR(product.revenue),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF10B981),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
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
