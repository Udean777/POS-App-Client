import 'package:client/features/profile/presentation/providers/profile_provider.dart';
import 'package:client/features/dashboard/presentation/widgets/dashboard_action_card.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:client/core/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AllMenuScreen extends ConsumerWidget {
  const AllMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Semua Menu", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
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
                color: AppColors.warning,
                onTap: () => context.pushNamed('pos'),
              ),
              if (isOwner)
                DashboardActionCard(
                  title: "Kelola Staf",
                  subtitle: "Atur hak akses karyawan",
                  icon: Icons.people_outline,
                  color: AppColors.success,
                  onTap: () => context.pushNamed('staff'),
                ),
              DashboardActionCard(
                title: "Riwayat",
                subtitle: "Riwayat transaksi",
                icon: Icons.history,
                color: AppColors.info,
                onTap: () => context.pushNamed('history'),
              ),
              DashboardActionCard(
                title: "Pengaturan",
                subtitle: "Konfigurasi toko & profil",
                icon: Icons.settings_outlined,
                color: AppColors.textSecondary,
                onTap: () => context.pushNamed(RouteNames.storeConfig),
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
