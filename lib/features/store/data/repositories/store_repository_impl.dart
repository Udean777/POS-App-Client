import 'package:client/core/errors/failure.dart';
import 'package:client/features/store/data/datasources/store_remote_data_source.dart';
import 'package:client/features/store/domain/repositories/store_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;

  StoreRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  }) async {
    try {
      await remoteDataSource.updateBusiness(
        name: name,
        type: type,
        address: address,
        phone: phone,
        logoUrl: logoUrl,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(e.response?.data['error'] ?? 'Gagal memperbarui bisnis'));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
