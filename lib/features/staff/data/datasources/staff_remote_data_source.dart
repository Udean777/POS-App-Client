import 'package:client/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';

abstract class StaffRemoteDataSource {
  Future<void> createStaff(String email, String password, String role);
  Future<List<UserModel>> fetchStaff();
}

class StaffRemoteDataSourceImpl implements StaffRemoteDataSource {
  final Dio _dio;

  StaffRemoteDataSourceImpl(this._dio);

  @override
  Future<void> createStaff(String email, String password, String role) async {
    await _dio.post(
      '/staff',
      data: {'email': email, 'password': password, 'role': role},
    );
  }

  @override
  Future<List<UserModel>> fetchStaff() async {
    final response = await _dio.get('/staff');
    final List list = response.data;
    return list.map((e) => UserModel.fromJson(e)).toList();
  }
}
