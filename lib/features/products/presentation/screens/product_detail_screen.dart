import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_actions_notifier.dart';
import 'package:client/features/products/presentation/providers/product_detail_provider.dart';
import 'package:client/features/products/presentation/widgets/edit_variant_dialog.dart';
import 'package:client/features/products/presentation/widgets/product_variant_list_item.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/core/presentation/widgets/app_dialog.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(productId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: productAsync.when(
        data: (product) {
          final totalStock = product.variants.isNotEmpty
              ? product.variants.map((v) => v.stock).reduce((a, b) => a + b)
              : 0;
          final minPrice = product.variants.isNotEmpty
              ? product.variants
                    .map((v) => v.price)
                    .reduce((a, b) => a < b ? a : b)
              : 0.0;

          return RefreshIndicator(
            onRefresh: () async =>
                ref.refresh(productDetailProvider(productId)),
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, ref, product),
                _buildProductInfo(context, product, totalStock, minPrice),
                _buildVariantList(context, ref, product),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => _buildErrorState(ref, err),
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      stretch: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.shadow.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          product.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: AppColors.shadow.withValues(alpha: 0.5),
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        background: Hero(
          tag: 'product_image_${product.id}',
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                CachedNetworkImage(
                  imageUrl: product.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.primary,
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                )
              else
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppGradients.primary,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              // Overlay Gradient for text readability
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.center,
                    colors: [
                      AppColors.shadow.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.shadow.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.edit, color: Colors.white, size: 20),
              onPressed: () =>
                  context.push('/products/${product.id}/edit', extra: product),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.shadow.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => _showDeleteDialog(context, ref, product),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(
    BuildContext context,
    ProductEntity product,
    int totalStock,
    double minPrice,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
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
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat(
                  context,
                  Icons.sell_outlined,
                  "Mulai",
                  product.variants.isNotEmpty
                      ? CurrencyFormatter.toIDR(minPrice)
                      : "-",
                  isPrice: true,
                ),
                Container(width: 1, height: 40, color: AppColors.border),
                _buildSummaryStat(
                  context,
                  Icons.inventory_2_outlined,
                  "Total Stok",
                  "$totalStock",
                ),
                Container(width: 1, height: 40, color: AppColors.border),
                _buildSummaryStat(
                  context,
                  Icons.layers_outlined,
                  "Varian",
                  "${product.variants.length}",
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Deskripsi Produk",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text(
            product.description.isEmpty
                ? "Tidak ada deskripsi."
                : product.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pilihan Varian",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                "${product.variants.length} Varian",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _buildSummaryStat(
    BuildContext context,
    IconData icon,
    String label,
    String value, {
    bool isPrice = false,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppColors.textLight),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isPrice ? AppColors.success : AppColors.textHeadline,
          ),
        ),
      ],
    );
  }

  Widget _buildVariantList(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final variant = product.variants[index];
          return ProductVariantListItem(
            variant: variant,
            onEdit: () =>
                _handleVariantEdit(context, ref, product, variant, index),
          );
        }, childCount: product.variants.length),
      ),
    );
  }

  Widget _buildErrorState(WidgetRef ref, Object err) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.danger),
          const SizedBox(height: 16),
          Text("Error: $err", textAlign: TextAlign.center),
          const SizedBox(height: 24),
          AppButton(
            isFullWidth: false,
            onPressed: () => ref.refresh(productDetailProvider(productId)),
            text: "Coba Lagi",
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) {
    AppDialogs.showConfirm(
      context: context,
      title: "Hapus Produk",
      message: "Apakah Anda yakin ingin menghapus produk ini?",
      confirmText: "Hapus",
      isDanger: true,
    ).then((confirmed) {
      if (confirmed == true) {
        ref
            .read(productActionsProvider.notifier)
            .deleteProduct(product.id)
            .then((_) {
              if (context.mounted) {
                context.pop();
              }
            });
      }
    });
  }

  void _handleVariantEdit(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
    VariantEntity variant,
    int index,
  ) {
    AppDialogs.show(
      context: context,
      child: EditVariantDialog(
        variant: variant,
        onSave: (newVariant) {
          final newVariants = List<VariantEntity>.from(product.variants);
          newVariants[index] = newVariant;
          final newProduct = product.copyWith(variants: newVariants);

          ref
              .read(productActionsProvider.notifier)
              .updateProduct(newProduct)
              .then((_) {
                if (context.mounted) {
                  ref.invalidate(productDetailProvider(product.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Varian ${variant.name} berhasil diperbarui",
                      ),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              });
        },
      ),
    );
  }
}
