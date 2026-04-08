import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/data/models/auth_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class StaffRepository {
  Future<Either<Failure, void>> createStaff({
    required String email,
    required String password,
    required String role,
  });
  Future<Either<Failure, List<UserModel>>> getStaff();
}
