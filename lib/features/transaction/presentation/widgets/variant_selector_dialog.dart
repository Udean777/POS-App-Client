import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/core/presentation/widgets/app_dialog.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class VariantSelectorDialog extends StatelessWidget {
  final ProductEntity product;

  const VariantSelectorDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      padding: EdgeInsets.zero,
      borderRadius: 28,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with product image/icon
          _buildHeader(),

          // Variant list
          _buildVariantList(),

          // Cancel button
          _buildCancelButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Product image or icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Icon(
                        Icons.inventory_2,
                        color: Colors.white70,
                        size: 32,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.inventory_2,
                        color: Colors.white70,
                        size: 32,
                      ),
                    )
                  : const Icon(
                      Icons.inventory_2,
                      color: Colors.white70,
                      size: 32,
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            "${product.variants.length} varian tersedia",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariantList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        itemCount: product.variants.length,
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final v = product.variants[index];
          final isOutOfStock = v.stock <= 0;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.pop(context, v),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isOutOfStock
                      ? Colors.red.withValues(alpha: 0.03)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOutOfStock
                        ? Colors.red.withValues(alpha: 0.15)
                        : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  children: [
                    // Variant icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? AppColors.dangerOpaque
                            : AppColors.primaryOpaque,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        isOutOfStock
                            ? Icons.remove_shopping_cart_outlined
                            : Icons.style_outlined,
                        color: isOutOfStock
                            ? AppColors.danger
                            : AppColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Variant info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: isOutOfStock
                                  ? AppColors.dangerOpaque
                                  : AppColors.successOpaque,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isOutOfStock ? "Stok habis" : "Stok: ${v.stock}",
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: isOutOfStock
                                        ? AppColors.danger
                                        : AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          CurrencyFormatter.toIDR(v.price),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey[400],
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: AppTextButton(
        onPressed: () => Navigator.pop(context),
        text: "Batal",
        color: AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
