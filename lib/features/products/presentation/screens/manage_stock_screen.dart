import 'package:client/src/theme/app_theme.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_actions_notifier.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageStockScreen extends ConsumerStatefulWidget {
  const ManageStockScreen({super.key});

  @override
  ConsumerState<ManageStockScreen> createState() => _ManageStockScreenState();
}

class _ManageStockScreenState extends ConsumerState<ManageStockScreen> {
  String _searchQuery = '';
  String _activeFilter = 'Semua';

  final List<String> _filters = ['Semua', 'Habis', '1-10', '11-20', '>20'];

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Atur Stok"), centerTitle: true),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari produk atau SKU...",
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Filter Chips
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filters.length,
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = filter == _activeFilter;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _activeFilter = filter;
                      });
                    },
                    selectedColor: AppColors.primaryOpaque,
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // List View
          Expanded(
            child: productsState.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text("Belum ada produk."));
                }

                // Gather all variants
                final allVariants = <Map<String, dynamic>>[];
                for (var product in products) {
                  for (var variant in product.variants) {
                    allVariants.add({'product': product, 'variant': variant});
                  }
                }

                // Filter and Search
                var filteredVariants = allVariants.where((item) {
                  final ProductEntity product = item['product'];
                  final VariantEntity variant = item['variant'];
                  final searchTerm = _searchQuery.toLowerCase();

                  // Search logic
                  if (_searchQuery.isNotEmpty) {
                    final isMatch =
                        product.name.toLowerCase().contains(searchTerm) ||
                        variant.name.toLowerCase().contains(searchTerm) ||
                        variant.sku.toLowerCase().contains(searchTerm);
                    if (!isMatch) return false;
                  }

                  // Filter logic
                  if (_activeFilter == 'Habis') return variant.stock == 0;
                  if (_activeFilter == '1-10')
                    return variant.stock >= 1 && variant.stock <= 10;
                  if (_activeFilter == '11-20')
                    return variant.stock >= 11 && variant.stock <= 20;
                  if (_activeFilter == '>20') return variant.stock > 20;

                  return true;
                }).toList();

                // Sort: Lowest stock first
                filteredVariants.sort((a, b) {
                  final int stockA = (a['variant'] as VariantEntity).stock;
                  final int stockB = (b['variant'] as VariantEntity).stock;
                  return stockA.compareTo(stockB);
                });

                if (filteredVariants.isEmpty) {
                  return const Center(
                    child: Text("Tidak ada varian yang sesuai."),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: filteredVariants.length,
                  itemBuilder: (ctx, index) {
                    final item = filteredVariants[index];
                    final ProductEntity product = item['product'];
                    final VariantEntity variant = item['variant'];

                    final bool isLowStock = variant.stock <= 10;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: isLowStock
                            ? const BorderSide(color: AppColors.danger)
                            : BorderSide.none,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: CircleAvatar(
                          backgroundColor: isLowStock
                              ? AppColors.dangerOpaque
                              : AppColors.primaryOpaque,
                          child: Icon(
                            Icons.inventory,
                            color: isLowStock
                                ? AppColors.danger
                                : AppColors.primary,
                          ),
                        ),
                        title: Text(
                          "${product.name} - ${variant.name}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Sisa stok: ${variant.stock} | SKU: ${variant.sku}",
                          style: TextStyle(
                            color: isLowStock
                                ? AppColors.danger
                                : AppColors.textSecondary,
                            fontWeight: isLowStock
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              _showRestockPrompt(context, ref, variant),
                          child: const Text("Restock"),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text("Gagal memuat data: $err")),
            ),
          ),
        ],
      ),
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
