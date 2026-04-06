import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:client/features/transaction/presentation/providers/cart_provider.dart';
import 'package:client/features/transaction/presentation/screens/transaction_history_screen.dart';
import 'package:client/features/transaction/presentation/widgets/checkout_bottom_sheet.dart';
import 'package:client/features/transaction/presentation/widgets/variant_selector_dialog.dart';
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
      backgroundColor: Colors.grey[100],
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
                        final totalStock = product.variants.fold<int>(
                          0,
                          (total, v) => total + v.stock,
                        );

                        return GestureDetector(
                          onTap: () => _handleProductTap(context, ref, product),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF6366F1,
                                      ).withValues(alpha: 0.1),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.inventory_2,
                                      size: 40,
                                      color: Color(0xFF6366F1),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        product.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      if (product.description.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          product.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500],
                                            height: 1.2,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: totalStock > 0
                                              ? const Color(
                                                  0xFF10B981,
                                                ).withValues(alpha: 0.1)
                                              : Colors.red.withValues(
                                                  alpha: 0.1,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          "Stok: $totalStock",
                                          style: TextStyle(
                                            color: totalStock > 0
                                                ? const Color(0xFF10B981)
                                                : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Error: $err")),
            ),
          ),
          if (cartCount > 0)
            Container(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom:
                    MediaQuery.of(context).padding.bottom +
                    12, // Safe area bottom
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$cartCount barang di keranjang",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          CurrencyFormatter.toIDR(cartTotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      try {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (sheetContext) =>
                              const CheckoutBottomSheet(),
                        );
                      } catch (e) {
                        debugPrint("Error opening bottom sheet: $e");
                      }
                    },
                    child: const Text("Checkout"),
                  ),
                ],
              ),
            ),
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
    final variant = await showDialog<VariantEntity>(
      context: context,
      builder: (dialogContext) => VariantSelectorDialog(product: product),
    );

    if (variant != null && context.mounted) {
      _addToCart(context, ref, product, variant);
    }
  }

  void _addToCart(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
    VariantEntity variant,
  ) {
    if (variant.stock <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text("Stok Kosong"),
            ],
          ),
          content: Text(
            "Stok untuk ${product.name} - ${variant.name} habis.\nMohon minta orang gudang untuk update stok.\n\nApakah Anda tetap ingin melanjutkan transaksi?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () {
                Navigator.pop(context);
                ref.read(cartProvider.notifier).addItem(product, variant);
              },
              child: const Text("Tetap Jual"),
            ),
          ],
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
