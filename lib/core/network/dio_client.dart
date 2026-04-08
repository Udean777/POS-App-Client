import 'package:client/core/constants/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  DioClient(this._dio, this._storage) {
    _dio
      ..options.baseUrl = AppConstants.baseUrl
      ..options.connectTimeout = const Duration(seconds: 15)
      ..options.receiveTimeout = const Duration(seconds: 15)
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            final token = await _storage.read(key: AppConstants.tokenKey);
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
            return handler.next(options);
          },
          onError: (DioException e, handler) async {
            if (e.response?.statusCode == 401) {
              final refreshToken = await _storage.read(
                key: AppConstants.refreshTokenKey,
              );

              if (refreshToken != null) {
                try {
                  final refreshDio = Dio(
                    BaseOptions(baseUrl: AppConstants.baseUrl),
                  );
                  final response = await refreshDio.post(
                    '/auth/refresh',
                    data: {'refresh_token': refreshToken},
                  );

                  if (response.statusCode == 200) {
                    final newAccessToken = response.data['access_token'];
                    final newRefreshToken = response.data['refresh_token'];

                    await _storage.write(
                      key: AppConstants.tokenKey,
                      value: newAccessToken,
                    );
                    await _storage.write(
                      key: AppConstants.refreshTokenKey,
                      value: newRefreshToken,
                    );

                    // Retry request asli dengan token baru
                    e.requestOptions.headers['Authorization'] =
                        'Bearer $newAccessToken';
                    final clonedRequest = await _dio.fetch(e.requestOptions);
                    return handler.resolve(clonedRequest);
                  }
                } catch (refreshError) {
                  // Jika refresh gagal, hapus token dan biarkan error 401 mengalir
                  await _storage.delete(key: AppConstants.tokenKey);
                  await _storage.delete(key: AppConstants.refreshTokenKey);
                }
              }
            }
            return handler.next(e);
          },
        ),
      );
  }

  Dio get instance => _dio;
}
