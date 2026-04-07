import 'package:cached_network_image/cached_network_image.dart';
import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/core/presentation/widgets/app_dialog.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class VariantSelectorDialog extends StatefulWidget {
  final ProductEntity product;

  const VariantSelectorDialog({super.key, required this.product});

  @override
  State<VariantSelectorDialog> createState() => _VariantSelectorDialogState();
}

class _VariantSelectorDialogState extends State<VariantSelectorDialog> {
  final Set<int> _selectedIndices = {};

  ProductEntity get product => widget.product;

  bool get _hasSelection => _selectedIndices.isNotEmpty;

  void _toggleVariant(int index) {
    setState(() {
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _confirmSelection() {
    final selectedVariants = _selectedIndices
        .map((i) => product.variants[i])
        .toList();
    Navigator.pop(context, selectedVariants);
  }

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

          // Action buttons
          _buildActionButtons(context),
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
            "Pilih varian (${product.variants.length} tersedia)",
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
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final v = product.variants[index];
          final isOutOfStock = v.stock <= 0;
          final isSelected = _selectedIndices.contains(index);

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: isOutOfStock ? null : () => _toggleVariant(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isOutOfStock
                      ? Colors.red.withValues(alpha: 0.03)
                      : isSelected
                      ? AppColors.primary.withValues(alpha: 0.08)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isOutOfStock
                        ? Colors.red.withValues(alpha: 0.15)
                        : isSelected
                        ? AppColors.primary
                        : Colors.grey[200]!,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Checkbox indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? Colors.grey[200]
                            : isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isOutOfStock
                              ? Colors.grey[300]!
                              : isSelected
                              ? AppColors.primary
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    // Variant icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isOutOfStock
                            ? AppColors.dangerOpaque
                            : isSelected
                            ? AppColors.primary.withValues(alpha: 0.15)
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
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: isOutOfStock ? Colors.grey[400] : null,
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
                    Text(
                      CurrencyFormatter.toIDR(v.price),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isOutOfStock
                            ? Colors.grey[400]
                            : AppColors.success,
                      ),
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          // Selected count indicator
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: _hasSelection
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${_selectedIndices.length} varian dipilih",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Confirm button
          AppButton(
            onPressed: _hasSelection ? _confirmSelection : null,
            text: "Konfirmasi",
            icon: const Icon(Icons.check_rounded, size: 20),
          ),
          const SizedBox(height: 8),

          // Cancel button
          AppTextButton(
            onPressed: () => Navigator.pop(context),
            text: "Batal",
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
