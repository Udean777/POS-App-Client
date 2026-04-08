import 'package:client/features/staff/domain/repositories/staff_repository.dart';
import 'package:client/features/staff/domain/usecases/create_staff_usecase.dart';
import 'package:client/features/staff/domain/usecases/get_staff_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  throw UnimplementedError();
});

final createStaffUsecaseProvider = Provider((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return CreateStaffUsecase(repository);
});

final getStaffUsecaseProvider = Provider((ref) {
  final repository = ref.watch(staffRepositoryProvider);
  return GetStaffUsecase(repository);
});
