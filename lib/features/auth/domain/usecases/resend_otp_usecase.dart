import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ResendOTPUsecase {
  final AuthRepository repository;

  ResendOTPUsecase(this.repository);

  Future<Either<Failure, void>> execute({required String email}) {
    return repository.resendOTP(email: email);
  }
}
