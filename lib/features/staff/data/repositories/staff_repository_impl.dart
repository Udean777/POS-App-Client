import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/data/models/auth_model.dart';
import 'package:client/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:client/features/staff/domain/repositories/staff_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class StaffRepositoryImpl implements StaffRepository {
  final StaffRemoteDataSource remoteDataSource;

  StaffRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> createStaff({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      await remoteDataSource.createStaff(email, password, role);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        Failure(e.response?.data['error'] ?? 'Gagal mendaftarkan staf'),
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getStaff() async {
    try {
      final result = await remoteDataSource.fetchStaff();
      return Right(result);
    } on DioException catch (e) {
      return Left(
        Failure(e.response?.data['error'] ?? 'Gagal mengambil data staf'),
      );
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
