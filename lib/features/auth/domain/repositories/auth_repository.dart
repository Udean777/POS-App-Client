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

  Future<Either<Failure, void>> createStaff({
    required String email,
    required String password,
    required String role,
  });

  Future<Either<Failure, List<UserEntity>>> getStaff();

  Future<Either<Failure, void>> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  });
}
