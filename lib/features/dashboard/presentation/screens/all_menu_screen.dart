import 'package:client/features/auth/presentation/providers/profile_provider.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_action_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AllMenuScreen extends ConsumerWidget {
  const AllMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text("Semua Menu"), centerTitle: true),
      body: profileAsync.when(
        data: (user) {
          final bool isOwner = user.role == "OWNER";

          return GridView.count(
            padding: const EdgeInsets.all(24),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.9,
            children: [
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
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
