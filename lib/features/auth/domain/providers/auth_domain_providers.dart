import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:client/features/auth/domain/usecases/create_staff_usecase.dart';
import 'package:client/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:client/features/auth/domain/usecases/get_staff_usecase.dart';
import 'package:client/features/auth/domain/usecases/login_usecase.dart';
import 'package:client/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError();
});

final loginUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository);
});

final registerUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(repository);
});

final getProfileUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetProfileUsecase(repository);
});

final createStaffUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return CreateStaffUsecase(repository);
});

final getStaffUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetStaffUsecase(repository);
});
