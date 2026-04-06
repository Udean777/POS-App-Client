import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/transaction/presentation/providers/cart_provider.dart';
import 'package:client/features/transaction/presentation/providers/checkout_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

class CheckoutBottomSheet extends ConsumerStatefulWidget {
  const CheckoutBottomSheet({super.key});

  @override
  ConsumerState<CheckoutBottomSheet> createState() =>
      _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends ConsumerState<CheckoutBottomSheet> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleCheckout(double totalTagihan) {
    String rawInput = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (rawInput.isEmpty) rawInput = "0";

    double amountPaid = double.parse(rawInput);

    if (amountPaid < totalTagihan) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.flatColored,
        title: const Text("Uang kurang dari total tagihan!"),
        alignment: Alignment.topCenter,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
      );
      return;
    }

    ref
        .read(checkoutProvider.notifier)
        .processCheckout(
          amountPaid: amountPaid,
          paymentMethod: "CASH", 
          onSuccess: (transaction) {
            Navigator.pop(context); 
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Transaksi Berhasil!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Kembalian: ${CurrencyFormatter.toIDR(transaction.change)}",
                    ),
                  ],
                ),
                actions: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Tutup"),
                    ),
                  ),
                ],
              ),
            );
          },
          onError: (error) {
            toastification.show(
              context: context,
              type: ToastificationType.error,
              style: ToastificationStyle.flatColored,
              title: Text(error),
              alignment: Alignment.topCenter,
              autoCloseDuration: const Duration(seconds: 3),
              showProgressBar: false,
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final totalTagihan = ref.watch(cartProvider.notifier).getTotalPrice();
    final isLoading = ref.watch(checkoutProvider).isLoading;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Rincian Pesanan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.3,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.variant.name,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  "Sisa Stok: ${item.variant.stock}",
                                  style: TextStyle(
                                    color: item.quantity >= item.variant.stock
                                        ? Colors.red
                                        : Colors.grey[600],
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.toIDR(item.variant.price),
                              style: const TextStyle(
                                color: Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.red[300],
                            onPressed: () => ref
                                .read(cartProvider.notifier)
                                .updateQuantity(item.id, item.quantity - 1),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${item.quantity}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            color: item.quantity >= item.variant.stock
                                ? Colors.grey[300]
                                : const Color(0xFF6366F1),
                            onPressed: item.quantity >= item.variant.stock
                                ? null 
                                : () => ref
                                      .read(cartProvider.notifier)
                                      .updateQuantity(
                                        item.id,
                                        item.quantity + 1,
                                      ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Tagihan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                CurrencyFormatter.toIDR(totalTagihan),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Jumlah Uang (Rp)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            onChanged: (value) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Masukkan uang yang diterima",
              prefixIcon: const Icon(Icons.money),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          Builder(
            builder: (context) {
              String rawInput = _amountController.text.replaceAll(
                RegExp(r'[^0-9]'),
                '',
              );
              double amountPaid = rawInput.isEmpty ? 0 : double.parse(rawInput);

              if (amountPaid == 0) return const SizedBox.shrink();

              double kembalian = amountPaid - totalTagihan;

              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      kembalian < 0 ? "Sisa Kekurangan" : "Total Kembalian",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: kembalian < 0
                            ? Colors.red
                            : const Color(0xFF10B981),
                      ),
                    ),
                    Text(
                      CurrencyFormatter.toIDR(
                        kembalian < 0 ? kembalian.abs() : kembalian,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: kembalian < 0
                            ? Colors.red
                            : const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isLoading || cartItems.isEmpty
                ? null
                : () => _handleCheckout(totalTagihan),
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : const Text(
                    "Proses Pembayaran (CASH)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}
