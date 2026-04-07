import 'package:client/features/auth/domain/entities/user_entity.dart';
import 'package:client/features/auth/domain/providers/auth_domain_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'staff_provider.g.dart';

@riverpod
class StaffList extends _$StaffList {
  @override
  Future<List<UserEntity>> build() async {
    final usecase = ref.watch(getStaffUsecaseProvider);
    final result = await usecase.execute();
    return result.fold(
      (failure) => throw failure.message,
      (staff) => staff,
    );
  }

  Future<void> addStaff({
    required String email,
    required String password,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    state = const AsyncValue.loading();
    final usecase = ref.read(createStaffUsecaseProvider);
    final result = await usecase.execute(email: email, password: password);

    result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        onError(failure.message);
      },
      (_) async {
        // Refresh list after success
        ref.invalidateSelf();
        onSuccess("Staf berhasil didaftarkan");
      },
    );
  }
}
