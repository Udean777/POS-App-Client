import 'package:client/features/staff/presentation/providers/staff_provider.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddStaffScreen extends ConsumerStatefulWidget {
  const AddStaffScreen({super.key});

  @override
  ConsumerState<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends ConsumerState<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'STAFF';

  final List<String> _roles = ['ADMIN', 'KASIR', 'GUDANG', 'STAFF'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(staffListProvider.notifier)
        .addStaff(
          email: _emailController.text,
          password: _passwordController.text,
          role: _selectedRole,
          onSuccess: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          },
          onError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error), backgroundColor: AppColors.danger),
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Daftar Staf Baru",
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: AppColors.textHeadline),
        ),
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textHeadline),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Informasi Akun",
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: AppColors.textHeadline),
              ),
              const SizedBox(height: 8),
              Text(
                "Daftarkan email dan password untuk akun karyawan Anda.",
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),

              // Email Field
              AppTextField(
                controller: _emailController,
                labelText: "Email Karyawan",
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
              ),
              const SizedBox(height: 20),

              // Password Field
              AppTextField(
                controller: _passwordController,
                isPassword: true,
                labelText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                validator: (v) => v!.length < 6 ? "Minimal 6 karakter" : null,
              ),
              const SizedBox(height: 20),

              // Role Selection
              DropdownButtonFormField<String>(
                initialValue: _selectedRole,
                decoration: const InputDecoration(
                  labelText: "Pilih Role / Jabatan",
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                items: _roles
                    .map(
                      (role) =>
                          DropdownMenuItem(value: role, child: Text(role)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedRole = v);
                },
              ),
              const SizedBox(height: 48),

              // Submit Button
              AppButton(
                onPressed: _submit,
                isLoading: ref.watch(staffListProvider).isLoading,
                text: "Simpan Data Staf",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
