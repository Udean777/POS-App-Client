import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ProductListItem extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const ProductListItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final minPrice = product.variants.isNotEmpty
        ? product.variants.map((v) => v.price).reduce((a, b) => a < b ? a : b)
        : 0.0;
    final totalStock = product.variants.isNotEmpty
        ? product.variants.map((v) => v.stock).reduce((a, b) => a + b)
        : 0;

    return AppCard(
      margin: const EdgeInsets.only(bottom: 12),
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      border: Border.all(color: AppColors.border),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopSection(context),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          _buildBottomSection(context, minPrice, totalStock),
        ],
      ),
    );
  }

  Widget _buildTopSection(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Product Thumbnail
        Hero(
          tag: 'product_image_${product.id}',
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: product.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.primary,
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                : const Icon(
                    Icons.image_outlined,
                    color: AppColors.textLight,
                    size: 32,
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryOpaque,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.category,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (product.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(
    BuildContext context,
    double minPrice,
    int totalStock,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mulai dari",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              CurrencyFormatter.toIDR(minPrice),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.inventory_2_outlined, size: 16, color: AppColors.textLight),
            const SizedBox(width: 4),
            Text(
              "$totalStock Stok",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textBody,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 12),
            Icon(Icons.layers_outlined, size: 16, color: AppColors.textLight),
            const SizedBox(width: 4),
            Text(
              "${product.variants.length} Varian",
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textBody,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
