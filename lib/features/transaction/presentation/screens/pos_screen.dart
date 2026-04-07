import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:client/features/transaction/presentation/providers/cart_provider.dart';
import 'package:client/features/transaction/presentation/screens/transaction_history_screen.dart';
import 'package:client/features/transaction/presentation/widgets/empty_stock_warning_dialog.dart';
import 'package:client/features/transaction/presentation/widgets/pos_cart_bottom_bar.dart';
import 'package:client/features/transaction/presentation/widgets/pos_product_card.dart';
import 'package:client/features/transaction/presentation/widgets/variant_selector_dialog.dart';
import 'package:client/core/presentation/widgets/app_dialog.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productListProvider);
    final cartItems = ref.watch(cartProvider);

    final cartTotal = cartItems.fold<double>(
      0.0,
      (total, item) => total + item.subtotal,
    );
    final cartCount = cartItems.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Transaksi"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: productState.when(
              data: (products) => products.isEmpty
                  ? const Center(child: Text("Tidak ada produk tersedia"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return PosProductCard(
                          product: product,
                          onTap: () => _handleProductTap(context, ref, product),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
          ),
          PosCartBottomBar(cartCount: cartCount, cartTotal: cartTotal),
        ],
      ),
    );
  }

  void _handleProductTap(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) {
    if (product.variants.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produk tidak memiliki varian yang bisa dijual'),
        ),
      );
      return;
    }

    _showVariantDialogAsync(context, ref, product);
  }

  Future<void> _showVariantDialogAsync(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) async {
    final variants = await AppDialogs.show<List<VariantEntity>>(
      context: context,
      child: VariantSelectorDialog(product: product),
    );

    if (variants != null && variants.isNotEmpty && context.mounted) {
      for (final variant in variants) {
        _addToCart(context, ref, product, variant);
      }
    }
  }

  void _addToCart(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
    VariantEntity variant,
  ) {
    if (variant.stock <= 0) {
      AppDialogs.show(
        context: context,
        child: EmptyStockWarningDialog(
          product: product,
          variant: variant,
          onConfirm: () {
            ref.read(cartProvider.notifier).addItem(product, variant);
          },
        ),
      );
    } else {
      ref.read(cartProvider.notifier).addItem(product, variant);
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.flatColored,
        title: Text('${product.name} (${variant.name}) ditambahkan'),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 2),
        showProgressBar: false,
      );
    }
  }
}
