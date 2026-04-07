import 'package:client/features/auth/domain/entities/user_entity.dart';
import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/profile/presentation/providers/profile_provider.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:client/core/presentation/widgets/app_dialog.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:client/core/constants/route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Profil Saya"), centerTitle: true),
      body: profileAsync.when(
        data: (user) => ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Profile Card (User Info)
            _buildProfileCard(user),
            const SizedBox(height: 32),

            // Business Info Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Informasi Bisnis",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (user.role == "OWNER")
                  TextButton.icon(
                    onPressed: () => context.pushNamed(RouteNames.storeConfig),
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: const Text("Edit"),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoTile(
              context: context,
              icon: Icons.storefront_outlined,
              label: "Nama Bisnis",
              value: user.businessName,
            ),
            _buildInfoTile(
              context: context,
              icon: Icons.category_outlined,
              label: "Tipe Bisnis",
              value: user.businessType,
            ),
            _buildInfoTile(
              context: context,
              icon: Icons.location_on_outlined,
              label: "Alamat",
              value: user.businessAddress.isEmpty ? "-" : user.businessAddress,
            ),
            const SizedBox(height: 48),

            // Logout Button
            AppOutlineButton(
              onPressed: () => _showLogoutDialog(context, ref),
              variant: AppButtonVariant.danger,
              icon: const Icon(Icons.logout, color: AppColors.danger),
              text: "Keluar Akun",
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
      ),
    );
  }

  Widget _buildProfileCard(UserEntity user) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      gradient: AppGradients.primary,
      borderRadius: 24,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Color(0x3DFFFFFF), // white24
            child: Icon(Icons.person, size: 40, color: AppColors.card),
          ),
          const SizedBox(height: 16),
          Text(
            user.email,
            style: const TextStyle(
              color: AppColors.card,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0x3DFFFFFF), // white24
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              user.role,
              style: const TextStyle(color: AppColors.card, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryOpaque,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(value, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    AppDialogs.showConfirm(
      context: context,
      title: "Logout",
      message: "Apakah Anda yakin ingin keluar?",
      confirmText: "Keluar",
      isDanger: true,
    ).then((confirmed) {
      if (confirmed == true) {
        ref.read(authNotifierProvider.notifier).logout();
      }
    });
  }
}
