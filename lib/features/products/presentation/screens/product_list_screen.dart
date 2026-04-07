import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:client/features/products/presentation/widgets/product_list_item.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Katalog Produk", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: productState.when(
        data: (products) => products.isEmpty
            ? _buildEmptyState()
            : _buildList(context, ref, products),
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => context.push('/products/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            "Belum ada produk",
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List products) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => ref.read(productListProvider.notifier).refresh(),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductListItem(
            product: product,
            onTap: () => context.push('/products/${product.id}'),
          );
        },
      ),
    );
  }
}
