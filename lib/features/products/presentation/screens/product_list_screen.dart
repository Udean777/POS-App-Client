import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Katalog Produk"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(productListProvider.notifier).refresh(),
          ),
        ],
      ),
      body: productState.when(
        data: (products) => products.isEmpty
            ? const Center(child: Text("Belum ada produk"))
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  // Ambil harga terendah dari varian untuk ditampilkan
                  final minPrice = product.variants.isNotEmpty
                      ? product.variants
                            .map((v) => v.price)
                            .reduce((a, b) => a < b ? a : b)
                      : 0.0;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${product.category} • ${product.variants.length} Varian",
                      ),
                      trailing: Text(
                        CurrencyFormatter.toIDR(minPrice),
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigasi ke form tambah produk (nanti kita buat)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
