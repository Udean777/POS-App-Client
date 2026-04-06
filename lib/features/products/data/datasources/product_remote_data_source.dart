import 'package:client/features/products/data/models/product_model.dart';
import 'package:dio/dio.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
  Future<void> addProduct(Map<String, dynamic> productData);
  Future<void> updateProduct(String id, Map<String, dynamic> productData);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio _dio;

  ProductRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final response = await _dio.get('/products');
    final List data = response.data;
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _dio.post('/products', data: productData);
  }

  @override
  Future<void> updateProduct(
    String id,
    Map<String, dynamic> productData,
  ) async {
    await _dio.put('/products/$id', data: productData);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await _dio.delete('/products/$id');
  }
}
