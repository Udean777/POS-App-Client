import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResetPasswordUsecase {
  final AuthRepository _repository;

  ResetPasswordUsecase(this._repository);

  Future<Either<Failure, String>> execute({
    required String email,
    required String code,
    required String newPassword,
  }) {
    return _repository.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );
  }
}
