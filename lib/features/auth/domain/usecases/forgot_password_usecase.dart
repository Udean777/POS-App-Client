import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class ForgotPasswordUsecase {
  final AuthRepository _repository;

  ForgotPasswordUsecase(this._repository);

  Future<Either<Failure, void>> execute({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
