import 'package:client/core/constants/route_constants.dart';
import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:client/src/theme/app_theme.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        unverified: (email) {
          // Navigasi ke Reset Password (untuk Owner)
          // Backend mengembalikan unverified state untuk memicu input OTP
          context.pushNamed(RouteNames.resetPassword, extra: email);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Kode OTP telah dikirim ke email Anda'),
              backgroundColor: AppColors.success,
            ),
          );
        },
        error: (message) {
          if (message.contains('permintaan telah dikirim')) {
            // Berhasil untuk Staff (Ajuan)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.success,
              ),
            );
            context.pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        orElse: () {},
      );
    });

    final state = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
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
                "Lupa Password",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadline,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Masukkan email akun Anda untuk menerima instruksi reset password.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              AppTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                labelText: 'Email Akun',
                hintText: 'user@email.com',
                prefixIcon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 32),

              AppButton(
                text: 'Kirim Instruksi',
                isLoading: state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                ),
                onPressed: () {
                  if (_emailController.text.isNotEmpty) {
                    ref
                        .read(authNotifierProvider.notifier)
                        .forgotPassword(_emailController.text);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
