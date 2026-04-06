import 'package:client/features/auth/domain/entities/user_entity.dart';
import 'package:client/features/auth/domain/providers/auth_domain_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
Future<UserEntity> profile(Ref ref) async {
  final usecase = ref.watch(getProfileUsecaseProvider);
  final result = await usecase.execute();

  return result.fold(
    (failure) => throw failure.message,
    (user) => user,
  );
}
