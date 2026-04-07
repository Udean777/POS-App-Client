import 'package:client/core/utils/currency_formatter.dart';
import 'package:client/features/transaction/presentation/widgets/checkout_bottom_sheet.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';

class PosCartBottomBar extends StatelessWidget {
  final int cartCount;
  final double cartTotal;

  const PosCartBottomBar({
    super.key,
    required this.cartCount,
    required this.cartTotal,
  });

  @override
  Widget build(BuildContext context) {
    if (cartCount <= 0) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
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
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  CurrencyFormatter.toIDR(cartTotal),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          AppButton(
            isFullWidth: false,
            onPressed: () => _handleCheckout(context),
            text: "Checkout",
          ),
        ],
      ),
    );
  }

  void _handleCheckout(BuildContext context) {
    try {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (sheetContext) => const CheckoutBottomSheet(),
      );
    } catch (e) {
      debugPrint("Error opening bottom sheet: $e");
    }
  }
}
