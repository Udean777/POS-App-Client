import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProducts();

  Future<Either<Failure, void>> addProduct(ProductEntity product);

  Future<Either<Failure, void>> deleteProduct(String id);
}
