import 'package:client/features/profile/presentation/providers/profile_provider.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_shortcuts.dart';
import 'package:client/features/dashboard/presentation/widgets/sales_chart_widget.dart';
import 'package:client/features/dashboard/presentation/widgets/top_products_widget.dart';
import 'package:client/features/dashboard/presentation/widgets/low_stock_warning_card.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:client/features/transaction/presentation/providers/transaction_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);
    final transactionState = ref.watch(transactionListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50], // Background subtle modern
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileProvider);
          ref.invalidate(productListProvider);
          ref.invalidate(transactionListProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header Section (Profile + Revenue Report)
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (user) => transactionState.when(
                  data: (transactions) =>
                      DashboardHeader(user: user, transactions: transactions),
                  loading: () => const SizedBox(height: 200),
                  error: (err, _) => const SizedBox(),
                ),
                loading: () => const SizedBox(height: 200),
                error: (err, _) => const SizedBox(),
              ),
            ),

            const SliverToBoxAdapter(child: LowStockWarningCard()),
            
            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Menu Cepat (Horizontal)
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (user) {
                  final bool isOwner = user.role == "OWNER";

                  final List<ShortcutItem> displayedItems = [
                    ShortcutItem(
                      title: "Produk",
                      icon: Icons.inventory_2_outlined,
                      onTap: () => context.goNamed('products'),
                    ),
                    ShortcutItem(
                      title: "Transaksi",
                      icon: Icons.point_of_sale_outlined,
                      color: Colors.orange,
                      onTap: () => context.goNamed('pos'),
                    ),
                    if (isOwner)
                      ShortcutItem(
                        title: "Staf",
                        icon: Icons.people_outline,
                        color: Colors.teal,
                        onTap: () => context.pushNamed('staff'),
                      ),
                    ShortcutItem(
                      title: "Riwayat",
                      icon: Icons.history,
                      color: Colors.blue,
                      onTap: () => context.goNamed('history'),
                    ),
                  ];

                  return DashboardShortcuts(
                    onMoreTap: () => context.push('/all-menu'),
                    items: displayedItems,
                  );
                },
                loading: () => const SizedBox(height: 100),
                error: (err, _) => const SizedBox(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Sales Chart
            SliverToBoxAdapter(
              child: transactionState.when(
                data: (transactions) =>
                    SalesChartWidget(transactions: transactions),
                loading: () => const SizedBox(height: 200),
                error: (err, _) => const SizedBox(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // Top Products
            SliverToBoxAdapter(
              child: transactionState.when(
                data: (transactions) =>
                    TopProductsWidget(transactions: transactions),
                loading: () => const SizedBox(height: 150),
                error: (err, _) => const SizedBox(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
