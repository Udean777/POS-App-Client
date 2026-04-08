import 'package:client/core/constants/app_constants.dart';
import 'package:client/core/providers/core_providers.dart';
import 'package:client/features/auth/domain/providers/auth_domain_providers.dart';
import 'package:client/features/auth/presentation/providers/auth_status_provider.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_notifier.g.dart';

@Riverpod(name: 'authNotifierProvider')
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();

    final loginUsecase = ref.read(loginUsecaseProvider);
    final result = await loginUsecase.execute(email: email, password: password);

    if (!ref.mounted) return;

    await result.fold(
      (failure) async {
        state = AuthState.error(failure.message);
      },
      (token) async {
        // Token sudah disimpan di repository layer, di sini kita hanya perlu
        // validasi state dan navigasi.
        if (!ref.mounted) return;

        ref.invalidate(isAuthenticatedProvider);
        state = const AuthState.authenticated();
      },
    );
  }

  Future<void> register(
    String email,
    String password,
    String businessName,
  ) async {
    state = const AuthState.loading();

    final registerUsecase = ref.read(registerUsecaseProvider);
    final result = await registerUsecase.execute(
      email: email,
      password: password,
      businessName: businessName,
    );

    if (!ref.mounted) return;

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = const AuthState.initial(),
    );
  }

  Future<void> logout() async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: AppConstants.tokenKey);
    await storage.delete(key: AppConstants.refreshTokenKey);
    await storage.delete(key: AppConstants.userKey);

    if (!ref.mounted) return;

    state = const AuthState.initial();

    ref.invalidate(isAuthenticatedProvider);
  }
}
