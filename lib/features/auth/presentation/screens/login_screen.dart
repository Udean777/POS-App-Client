import 'package:client/core/constants/route_constants.dart';
import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:client/core/presentation/widgets/app_text_field.dart';
import 'package:client/core/presentation/widgets/app_button.dart';
import 'package:client/core/presentation/widgets/app_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:client/src/theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              content: Text('Login Berhasil!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
        unverified: (email) {
          context.goNamed(RouteNames.otp, extra: email);
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & Header
                AppCard(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.primaryOpaque,
                  boxShadow: const [], // No shadow for the logo box
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Selamat Datang!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeadline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Masuk untuk mengelola bisnis Anda dengan Modal POS",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),

                // Form
                AppTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  labelText: 'Email Bisnis',
                  hintText: 'admin@toko.com',
                  prefixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _passwordController,
                  isPassword: true,
                  labelText: 'Password',
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outlined),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: AppTextButton(
                    onPressed: () {
                      context.pushNamed(RouteNames.forgotPassword);
                    },
                    text: "Lupa Password?",
                  ),
                ),
                const SizedBox(height: 32),

                // Login Button
                AppButton(
                  text: 'Masuk Sekarang',
                  isLoading: state.maybeWhen(
                    loading: () => true,
                    orElse: () => false,
                  ),
                  onPressed: () {
                    ref
                        .read(authNotifierProvider.notifier)
                        .login(_emailController.text, _passwordController.text);
                  },
                ),
                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Belum punya akun?",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    AppTextButton(
                      onPressed: () => context.goNamed('register'),
                      text: "Daftar UMKM",
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
