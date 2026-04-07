import 'package:client/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<void> register(String email, String password, String businessName);
  Future<UserModel> fetchProfile();
  Future<void> createStaff(String email, String password, String role);
  Future<List<UserModel>> fetchStaff();
  Future<void> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  });
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

  @override
  Future<UserModel> fetchProfile() async {
    final response = await _dio.get('/me');
    return UserModel.fromJson(response.data);
  }

  @override
  Future<void> createStaff(String email, String password, String role) async {
    await _dio.post(
      '/auth/staff',
      data: {'email': email, 'password': password, 'role': role},
    );
  }

  @override
  Future<List<UserModel>> fetchStaff() async {
    final response = await _dio.get('/auth/staff');
    final List list = response.data;
    return list.map((e) => UserModel.fromJson(e)).toList();
  }

  @override
  Future<void> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  }) async {
    await _dio.put(
      '/auth/business',
      data: {
        'name': name,
        'type': type,
        'address': address,
        'phone': phone,
        'logo_url': logoUrl,
      },
    );
  }
}
