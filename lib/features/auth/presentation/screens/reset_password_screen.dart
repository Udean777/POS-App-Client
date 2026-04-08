import 'package:client/core/constants/route_constants.dart';
import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:client/src/theme/app_theme.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        authenticated: () {
          context.goNamed(RouteNames.dashboard);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password berhasil diubah dan Anda telah login!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: AppColors.danger),
          );
        },
        orElse: () {},
      );
    });

    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Reset Password'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Buat Password Baru",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadline,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Masukkan kode OTP yang dikirim ke email ${widget.email} dan ketikkan password baru Anda.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              AppTextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                labelText: 'Kode OTP (6 digit)',
                hintText: '123456',
                prefixIcon: const Icon(Icons.security),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _passwordController,
                isPassword: true,
                labelText: 'Password Baru',
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_outlined),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _confirmPasswordController,
                isPassword: true,
                labelText: 'Konfirmasi Password Baru',
                hintText: '••••••••',
                prefixIcon: const Icon(Icons.lock_reset_outlined),
              ),
              const SizedBox(height: 32),

              AppButton(
                text: 'Simpan Password Baru',
                isLoading: state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                ),
                onPressed: () {
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password konfirmasi tidak cocok'),
                        backgroundColor: AppColors.danger,
                      ),
                    );
                    return;
                  }

                  if (_otpController.text.length != 6) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode OTP harus 6 digit'),
                        backgroundColor: AppColors.danger,
                      ),
                    );
                    return;
                  }

                  ref
                      .read(authNotifierProvider.notifier)
                      .resetPassword(
                        email: widget.email,
                        code: _otpController.text,
                        newPassword: _passwordController.text,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
