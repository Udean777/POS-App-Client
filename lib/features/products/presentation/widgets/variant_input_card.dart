import 'package:client/features/products/domain/entities/product_entity.dart';
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    initialValue: variant.name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Varian',
                      hintText: 'Misal: Merah, XL, Pedas',
                    ),
                    onChanged: (v) => onChanged(variant.copyWith(name: v)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: variant.sku,
                    decoration: const InputDecoration(
                      labelText: 'SKU',
                      hintText: 'Kode produk',
                    ),
                    onChanged: (v) => onChanged(variant.copyWith(sku: v)),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: variant.price > 0
                        ? variant.price.toString()
                        : '',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      prefixText: 'Rp ',
                    ),
                    onChanged: (v) => onChanged(
                      variant.copyWith(price: double.tryParse(v) ?? 0),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: variant.stock > 0
                        ? variant.stock.toString()
                        : '',
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Stok'),
                    onChanged: (v) => onChanged(
                      variant.copyWith(stock: int.tryParse(v) ?? 0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
