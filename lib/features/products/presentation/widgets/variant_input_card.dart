import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class VariantInputCard extends StatelessWidget {
  final VariantEntity variant;
  final VoidCallback onDelete;
  final Function(VariantEntity) onChanged;

  const VariantInputCard({
    super.key,
    required this.variant,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AppTextField(
                  initialValue: variant.name,
                  labelText: 'Nama Varian',
                  hintText: 'Misal: Merah, XL, Pedas',
                  onChanged: (v) => onChanged(variant.copyWith(name: v)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: AppTextField(
                  initialValue: variant.sku,
                  labelText: 'SKU',
                  hintText: 'Kode produk',
                  onChanged: (v) => onChanged(variant.copyWith(sku: v)),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.danger,
                ),
                onPressed: onDelete,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  initialValue: variant.price > 0 ? variant.price.toString() : '',
                  keyboardType: TextInputType.number,
                  labelText: 'Harga',
                  prefixText: 'Rp ',
                  onChanged: (v) => onChanged(
                    variant.copyWith(price: double.tryParse(v) ?? 0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(
                  initialValue: variant.stock > 0 ? variant.stock.toString() : '',
                  keyboardType: TextInputType.number,
                  labelText: 'Stok',
                  onChanged: (v) => onChanged(
                    variant.copyWith(stock: int.tryParse(v) ?? 0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
