import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProductVariantListItem extends StatelessWidget {
  final VariantEntity variant;
  final VoidCallback onEdit;

  const ProductVariantListItem({
    super.key,
    required this.variant,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isOutOfStock = variant.stock <= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOutOfStock
              ? AppColors.danger.withValues(alpha: 0.3)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          variant.name,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      "SKU: ${variant.sku}",
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.toIDR(variant.price),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isOutOfStock
                        ? AppColors.dangerOpaque
                        : AppColors.successOpaque,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isOutOfStock ? "Stok Habis" : "Sisa: ${variant.stock}",
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isOutOfStock
                          ? AppColors.danger
                          : AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: AppColors.primary,
              ),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
