import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_action_card.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_stat_card.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productListProvider);
    final totalProducts = productState.maybeWhen(
      data: (products) => products.length.toString(),
      orElse: () => "0",
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header dengan Gradient dan Welcome Message
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () => _showLogoutDialog(context, ref),
                        icon: const Icon(Icons.logout, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Selamat Datang!",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "Modal POS Admin",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Statistik Ringkas
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: DashboardStatCard(
                      title: "Total Produk",
                      value: totalProducts,
                      icon: Icons.inventory_2,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: DashboardStatCard(
                      title: "Transaksi Hari Ini",
                      value: "0",
                      icon: Icons.shopping_cart,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Menu Navigasi (Grid)
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid(
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
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Transaksi segera hadir!")),
                    );
                  },
                ),
                DashboardActionCard(
                  title: "Laporan",
                  subtitle: "Pantau performa toko",
                  icon: Icons.analytics_outlined,
                  color: Colors.purple,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Laporan segera hadir!")),
                    );
                  },
                ),
                DashboardActionCard(
                  title: "Pengaturan",
                  subtitle: "Konfigurasi toko & profil",
                  icon: Icons.settings_outlined,
                  color: Colors.grey[700],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Fitur Pengaturan segera hadir!")),
                    );
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah Anda yakin ingin keluar?"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authNotifierProvider.notifier).logout();
            },
            child: const Text(
              "Keluar",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
