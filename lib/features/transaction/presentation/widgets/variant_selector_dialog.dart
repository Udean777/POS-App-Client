import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:flutter/material.dart';

class VariantSelectorDialog extends StatelessWidget {
  final ProductEntity product;

  const VariantSelectorDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pilih Varian ${product.name}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...product.variants.map((v) {
              return ListTile(
                title: Text(v.name),
                subtitle: Text("Stok: ${v.stock}"),
                trailing: Text(
                  CurrencyFormatter.toIDR(v.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  Navigator.pop(context, v);
                },
              );
            }),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Batal",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
