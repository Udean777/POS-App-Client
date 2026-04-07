import 'package:client/features/products/data/models/product_model.dart';
import 'package:dio/dio.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
  Future<ProductModel> fetchProductById(String id);
  Future<void> addProduct(Map<String, dynamic> productData);
  Future<void> updateProduct(String id, Map<String, dynamic> productData);
  Future<void> deleteProduct(String id);
  Future<void> restockVariant(String variantId, int quantity);
  Future<String> uploadImage(String filePath);
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
  Future<ProductModel> fetchProductById(String id) async {
    final response = await _dio.get('/products/$id');
    return ProductModel.fromJson(response.data);
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

  @override
  Future<void> restockVariant(String variantId, int quantity) async {
    await _dio.patch(
      '/products/variants/$variantId/restock',
      data: {'quantity': quantity},
    );
  }

  @override
  Future<String> uploadImage(String filePath) async {
    final fileName = filePath.split('/').last;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final response = await _dio.post('/products/upload', data: formData);
    return response.data['url'];
  }
}
