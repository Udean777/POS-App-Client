import 'package:client/features/auth/presentation/providers/profile_provider.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_action_card.dart';
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
      body: CustomScrollView(
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

          // Menu Navigasi (Grid)
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: profileAsync.when(
              data: (user) {
                final bool isOwner = user.role == "OWNER";

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildListDelegate([
                    DashboardActionCard(
                      title: "Produk",
                      subtitle: "Atur katalog dan stok",
                      icon: Icons.inventory_2_outlined,
                      onTap: () => context.pushNamed('products'),
                    ),
                    DashboardActionCard(
                      title: "Transaksi",
                      subtitle: "Mulai penjualan baru",
                      icon: Icons.point_of_sale_outlined,
                      color: Colors.orange,
                      onTap: () => context.pushNamed('pos'),
                    ),
                    // Hanya tampil jika OWNER
                    if (isOwner)
                      DashboardActionCard(
                        title: "Kelola Staf",
                        subtitle: "Atur hak akses karyawan",
                        icon: Icons.people_outline,
                        color: Colors.teal,
                        onTap: () => context.pushNamed('staff'),
                      ),
                    DashboardActionCard(
                      title: "Riwayat",
                      subtitle: "Riwayat transaksi",
                      icon: Icons.history,
                      color: Colors.blue,
                      onTap: () => context.pushNamed('history'),
                    ),
                    DashboardActionCard(
                      title: "Pengaturan",
                      subtitle: "Konfigurasi toko & profil",
                      icon: Icons.settings_outlined,
                      color: Colors.grey[700],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Fitur Pengaturan segera hadir!"),
                          ),
                        );
                      },
                    ),
                  ]),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) =>
                  SliverToBoxAdapter(child: Center(child: Text("Error: $err"))),
            ),
          ),
        ],
      ),
    );
  }
}
