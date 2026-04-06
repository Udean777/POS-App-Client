import 'package:client/core/constants/app_constants.dart';
import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:client/features/auth/domain/entities/user_entity.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl({required this.remoteDataSource, required this.storage});

  @override
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await remoteDataSource.login(email, password);

      await storage.write(key: AppConstants.tokenKey, value: result.token);

      return Right(result.token);
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      String message = 'Terjadi kesalahan pada server';

      if (data is Map) {
        message = data['error'] ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      return Left(Failure(message));
    } catch (e) {
      return Left(Failure('Koneksi bermasalah, silakan coba lagi'));
    }
  }

  @override
  Future<Either<Failure, void>> register({
    required String email,
    required String password,
    required String businessName,
  }) async {
    try {
      await remoteDataSource.register(email, password, businessName);
      return const Right(null);
    } on DioException catch (e) {
      final dynamic data = e.response?.data;
      String message = 'Gagal mendaftarkan akun';

      if (data is Map) {
        message = data['error'] ?? message;
      } else if (data is String && data.isNotEmpty) {
        message = data;
      }

      return Left(Failure(message));
    }
  }


  @override
  Future<Either<Failure, UserEntity>> getCurrentUser() {
    // TODO: implement getCurrentUse
    throw UnimplementedError();
  }
}
