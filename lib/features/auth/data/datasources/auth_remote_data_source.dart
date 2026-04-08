import 'package:client/features/auth/data/models/auth_model.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<void> register(String email, String password, String businessName);
  Future<UserModel> fetchProfile();
  Future<LoginResponse> refresh(String refreshToken);
  Future<LoginResponse> verifyOTP(String email, String code);
  Future<void> resendOTP(String email);
  Future<void> forgotPassword(String email);
  Future<LoginResponse> resetPassword(
    String email,
    String code,
    String newPassword,
  );
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
  Future<LoginResponse> refresh(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<LoginResponse> verifyOTP(String email, String code) async {
    final response = await _dio.post(
      '/auth/verify-otp',
      data: {'email': email, 'code': code},
    );
    return LoginResponse.fromJson(response.data);
  }

  @override
  Future<void> resendOTP(String email) async {
    await _dio.post('/auth/resend-otp', data: {'email': email});
  }

  @override
  Future<void> forgotPassword(String email) async {
    await _dio.post('/auth/forgot-password', data: {'email': email});
  }

  @override
  Future<LoginResponse> resetPassword(
    String email,
    String code,
    String newPassword,
  ) async {
    final response = await _dio.post(
      '/auth/reset-password',
      data: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      },
    );
    return LoginResponse.fromJson(response.data);
  }
}
