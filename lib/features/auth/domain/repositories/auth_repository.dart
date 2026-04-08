import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/entities/user_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String businessName,
  });

  Future<Either<Failure, UserEntity>> getCurrentUser();
  Future<Either<Failure, String>> refresh();

  Future<Either<Failure, String>> verifyOTP({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resendOTP({required String email});
  Future<Either<Failure, void>> forgotPassword({required String email});
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  });
}
