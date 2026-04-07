import 'package:client/features/staff/presentation/providers/staff_provider.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:client/core/presentation/widgets/app_card.dart';

class StaffListScreen extends ConsumerWidget {
  const StaffListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staffAsync = ref.watch(staffListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Manajemen Staf"), centerTitle: true),
      body: staffAsync.when(
        data: (staff) => RefreshIndicator(
          onRefresh: () async => ref.refresh(staffListProvider.future),
          child: staff.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  itemCount: staff.length,
                  itemBuilder: (context, index) {
                    final person = staff[index];
                    return _buildStaffCard(context, person);
                  },
                ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Gagal mengambil data: $err")),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed('add_staff'),
        label: const Text("Tambah Staf"),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.card,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 60,
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  "Belum ada staf terdaftar",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffCard(BuildContext context, person) {
    final bool isOwner = person.role == 'OWNER';

    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: (isOwner ? AppColors.primary : AppColors.warning)
                .withValues(alpha: 0.1),
            child: Icon(
              isOwner ? Icons.admin_panel_settings : Icons.person,
              color: isOwner ? AppColors.primary : AppColors.warning,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.email,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  isOwner ? "Pemilik Toko" : "Kasir / Staf",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: (isOwner ? AppColors.primary : AppColors.warning)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              person.role,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: isOwner ? AppColors.primary : AppColors.warning,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
