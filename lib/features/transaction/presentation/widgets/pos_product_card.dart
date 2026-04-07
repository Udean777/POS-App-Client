import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PosProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback onTap;

  const PosProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final totalStock = product.variants.fold<int>(
      0,
      (total, v) => total + v.stock,
    );

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: _buildImageSection()),
          Padding(
            padding: const EdgeInsets.all(12),
            child: _buildInfoSection(context, totalStock),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryOpaque,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        child: product.imageUrl != null && product.imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: product.imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.inventory_2,
                  size: 40,
                  color: AppColors.primary,
                ),
              )
            : const Icon(Icons.inventory_2, size: 40, color: AppColors.primary),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, int totalStock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        if (product.description.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            product.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: totalStock > 0
                ? AppColors.successOpaque
                : AppColors.dangerOpaque,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "Stok: $totalStock",
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: totalStock > 0 ? AppColors.success : AppColors.danger,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
