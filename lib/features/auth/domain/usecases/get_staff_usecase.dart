import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/entities/user_entity.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetStaffUsecase {
  final AuthRepository repository;

  GetStaffUsecase(this.repository);

  Future<Either<Failure, List<UserEntity>>> execute() async {
    return await repository.getStaff();
  }
}
