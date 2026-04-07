import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/transaction/presentation/providers/cart_provider.dart';
import 'package:client/features/transaction/presentation/providers/checkout_provider.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_dialog.dart';
import 'package:client/core/presentation/widgets/app_bottom_sheet.dart';
import 'package:client/src/theme/app_theme.dart';
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
            AppDialogs.showSuccess(
              context: context,
              title: "Transaksi Berhasil!",
              message:
                  "Kembalian: ${CurrencyFormatter.toIDR(transaction.change)}",
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

    return AppBottomSheet(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
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
                                      color: AppColors.success.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      item.variant.name,
                                      style: TextStyle(
                                        color: AppColors.success,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    "Sisa Stok: ${item.variant.stock - item.quantity}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color:
                                              item.quantity >=
                                                  item.variant.stock
                                              ? AppColors.danger
                                              : AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                CurrencyFormatter.toIDR(item.variant.price),
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              color: AppColors.danger.withValues(alpha: 0.5),
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
                                border: Border.all(color: AppColors.border),
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
                                  ? AppColors.border
                                  : AppColors.primary,
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
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
            AppTextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) => setState(() {}),
              labelText: "Jumlah Uang",
              hintText: "Masukkan uang yang diterima",
              prefixIcon: const Icon(Icons.money),
            ),

            Builder(
              builder: (context) {
                String rawInput = _amountController.text.replaceAll(
                  RegExp(r'[^0-9]'),
                  '',
                );
                double amountPaid = rawInput.isEmpty
                    ? 0
                    : double.parse(rawInput);

                if (amountPaid == 0) return const SizedBox.shrink();

                double kembalian = amountPaid - totalTagihan;

                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        kembalian < 0 ? "Sisa Kekurangan" : "Total Kembalian",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: kembalian < 0
                              ? AppColors.danger
                              : AppColors.success,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.toIDR(
                          kembalian < 0 ? kembalian.abs() : kembalian,
                        ),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: kembalian < 0
                                  ? AppColors.danger
                                  : AppColors.success,
                            ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: () => _handleCheckout(totalTagihan),
              isLoading: isLoading || cartItems.isEmpty,
              text: "Proses Pembayaran (CASH)",
            ),
          ],
        ),
      ),
    );
  }
}
