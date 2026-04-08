import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class VerifyOTPUsecase {
  final AuthRepository repository;

  VerifyOTPUsecase(this.repository);

  Future<Either<Failure, String>> execute({
    required String email,
    required String code,
  }) {
    return repository.verifyOTP(email: email, code: code);
  }
}
