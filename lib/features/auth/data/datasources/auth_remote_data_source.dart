import 'package:client/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<void> register(String email, String password, String businessName);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponse> login(String email, String password) async {
    final response = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<void> register(
    String email,
    String password,
    String businessName,
  ) async {
    await _dio.post(
      '/auth/register',
      data: {
        'email': email,
        'password': password,
        'business_name': businessName,
      },
    );
  }
}
