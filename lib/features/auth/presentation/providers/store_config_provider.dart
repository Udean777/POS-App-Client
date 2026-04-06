import 'package:client/features/auth/domain/providers/auth_domain_providers.dart';
import 'package:client/features/auth/presentation/providers/profile_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'store_config_provider.g.dart';

@riverpod
class StoreConfigNotifier extends _$StoreConfigNotifier {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  }) async {
    state = const AsyncValue.loading();
    final repository = ref.read(authRepositoryProvider);

    final result = await repository.updateBusiness(
      name: name,
      type: type,
      address: address,
      phone: phone,
      logoUrl: logoUrl,
    );

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        // Refresh profile to get updated business data
        ref.invalidate(profileProvider);
      },
    );
  }
}
