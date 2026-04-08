import 'package:client/src/theme/app_theme.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_actions_notifier.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LowStockWarningCard extends ConsumerWidget {
  const LowStockWarningCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productListProvider);

    return productsState.when(
      data: (products) {
        final lowStockVariants = <Map<String, dynamic>>[];
        for (var product in products) {
          for (var variant in product.variants) {
            if (variant.stock <= 10) {
              lowStockVariants.add({'product': product, 'variant': variant});
            }
          }
        }

        if (lowStockVariants.isEmpty) return const SizedBox.shrink();

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          color: AppColors.dangerOpaque,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.danger),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _showLowStockDialog(context, ref, lowStockVariants),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.danger,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Peringatan Stok Tipis!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.danger,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Ada ${lowStockVariants.length} varian produk yang butuh restock.",
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.danger),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  void _showLowStockDialog(
    BuildContext context,
    WidgetRef ref,
    List<Map<String, dynamic>> items,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Butuh Restock",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: items.length,
                    itemBuilder: (ctx, index) {
                      final item = items[index];
                      final ProductEntity product = item['product'];
                      final VariantEntity variant = item['variant'];

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.dangerOpaque,
                          child: const Icon(
                            Icons.inventory,
                            color: AppColors.danger,
                          ),
                        ),
                        title: Text("${product.name} - ${variant.name}"),
                        subtitle: Text(
                          "Sisa stok: ${variant.stock} | SKU: ${variant.sku}",
                          style: const TextStyle(color: AppColors.danger),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            _showRestockPrompt(context, ref, variant);
                          },
                          child: const Text("Restock"),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showRestockPrompt(
    BuildContext context,
    WidgetRef ref,
    VariantEntity variant,
  ) {
    final quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Restock Varian"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Varian: ${variant.name}"),
              const SizedBox(height: 16),
              TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah Tambahan",
                  border: OutlineInputBorder(),
                  hintText: "Contoh: 10",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final qty = int.tryParse(quantityController.text) ?? 0;
                if (qty <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Jumlah tidak valid")),
                  );
                  return;
                }

                Navigator.pop(ctx);
                await ref
                    .read(productActionsProvider.notifier)
                    .restockVariant(variant.id, qty);

                if (context.mounted) {
                  // Assuming error is handled via provider state observer, we just show success tip
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Restock berhasil!")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }
}
