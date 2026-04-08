import 'package:client/core/errors/failure.dart';
import 'package:client/features/staff/domain/repositories/staff_repository.dart';
import 'package:fpdart/fpdart.dart';

class CreateStaffUsecase {
  final StaffRepository repository;

  CreateStaffUsecase(this.repository);

  Future<Either<Failure, void>> execute({
    required String email,
    required String password,
    required String role,
  }) async {
    if (email.trim().isEmpty) {
      return Left(Failure('Email tidak boleh kosong'));
    }
    if (password.isEmpty) {
      return Left(Failure('Password tidak boleh kosong'));
    }
    return await repository.createStaff(
      email: email.trim(),
      password: password,
      role: role,
    );
  }
}
