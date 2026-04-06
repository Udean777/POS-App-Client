import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/data/datasources/product_remote_data_source.dart';
import 'package:client/features/products/data/models/product_model.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      final models = await remoteDataSource.fetchProducts();
      final entities = models.map((m) => m.toEntity()).toList();

      return Right(entities);
    } on DioException catch (e) {
      return Left(
        Failure(e.response?.data['error'] ?? "Gagal mengambil produk"),
      );
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getProduct(String id) async {
    try {
      final model = await remoteDataSource.fetchProductById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(
        Failure(e.response?.data['error'] ?? "Gagal mengambil data produk"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductEntity product) async {
    try {
      final data = {
        "name": product.name,
        "description": product.description,
        "category": product.category,
        "variants": product.variants
            .map(
              (v) => {
                "name": v.name,
                "price": v.price,
                "stock": v.stock,
                "sku": v.sku,
              },
            )
            .toList(),
      };

      await remoteDataSource.addProduct(data);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        Failure(e.response?.data['error'] ?? "Gagal menambah produk"),
      );
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductEntity product) async {
    try {
      final data = {
        "name": product.name,
        "description": product.description,
        "category": product.category,
        "variants": product.variants
            .map(
              (v) => {
                "id": v.id,
                "name": v.name,
                "price": v.price,
                "stock": v.stock,
                "sku": v.sku,
              },
            )
            .toList(),
      };

      await remoteDataSource.updateProduct(product.id, data);
      return const Right(null);
    } on DioException catch (e) {
      return Left(Failure(e.response?.data['error'] ?? "Gagal update produk"));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        Failure(e.response?.data['error'] ?? "Gagal menghapus produk"),
      );
    }
  }
}
