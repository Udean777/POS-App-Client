import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/data/models/auth_model.dart';
import 'package:client/features/staff/domain/repositories/staff_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetStaffUsecase {
  final StaffRepository repository;

  GetStaffUsecase(this.repository);

  Future<Either<Failure, List<UserModel>>> execute() async {
    return await repository.getStaff();
  }
}
