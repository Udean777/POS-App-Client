import 'package:client/features/auth/presentation/providers/profile_provider.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_shortcuts.dart';
import 'package:client/features/dashboard/presentation/widgets/sales_chart_widget.dart';
import 'package:client/features/dashboard/presentation/widgets/top_products_widget.dart';
import 'package:client/features/dashboard/presentation/widgets/stacked_stat_carousel.dart';
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
    final productState = ref.watch(productListProvider);
    final transactionState = ref.watch(transactionListProvider);

    final totalProducts = productState.maybeWhen(
      data: (products) => products.length.toString(),
      orElse: () => "0",
    );

    final transactionsToday = transactionState.maybeWhen(
      data: (transactions) {
        final now = DateTime.now();
        return transactions
            .where((tx) {
              final txDate = tx.createdAt.toLocal();
              return txDate.year == now.year &&
                  txDate.month == now.month &&
                  txDate.day == now.day;
            })
            .length
            .toString();
      },
      orElse: () => "0",
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(profileProvider);
          ref.invalidate(productListProvider);
          ref.invalidate(transactionListProvider);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header dan Statistik Ringkas
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 60, bottom: 8),
                child: StackedStatCarousel(
                  totalProducts: totalProducts,
                  transactionsToday: transactionsToday,
                ),
              ),
            ),

            // Menu Cepat (Horizontal)
            SliverToBoxAdapter(
              child: profileAsync.when(
                data: (user) {
                  final bool isOwner = user.role == "OWNER";
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16, top: 32),
                    child: DashboardShortcuts(
                      onMoreTap: () => context.push('/all-menu'),
                      items: [
                        ShortcutItem(
                          title: "Produk",
                          icon: Icons.inventory_2_outlined,
                          onTap: () => context.pushNamed('products'),
                        ),
                        ShortcutItem(
                          title: "Transaksi",
                          icon: Icons.point_of_sale_outlined,
                          color: Colors.orange,
                          onTap: () => context.pushNamed('pos'),
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
                          onTap: () => context.pushNamed('history'),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SizedBox(height: 100),
                error: (err, _) => const SizedBox(),
              ),
            ),

            // Sales Chart
            SliverToBoxAdapter(
              child: transactionState.when(
                data: (transactions) =>
                    SalesChartWidget(transactions: transactions),
                loading: () => const SizedBox(height: 200),
                error: (err, _) => const SizedBox(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Top Products
            SliverToBoxAdapter(
              child: transactionState.when(
                data: (transactions) =>
                    TopProductsWidget(transactions: transactions),
                loading: () => const SizedBox(height: 150),
                error: (err, _) => const SizedBox(),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
