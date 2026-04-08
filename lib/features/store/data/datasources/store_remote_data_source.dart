import 'package:dio/dio.dart';

abstract class StoreRemoteDataSource {
  Future<void> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  });
}

class StoreRemoteDataSourceImpl implements StoreRemoteDataSource {
  final Dio _dio;

  StoreRemoteDataSourceImpl(this._dio);

  @override
  Future<void> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  }) async {
    await _dio.put(
      '/business',
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
