import 'package:client/features/products/data/models/product_model.dart';
import 'package:dio/dio.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
  Future<void> addProduct(Map<String, dynamic> productData);
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
}
