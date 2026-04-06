import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProductUsecase {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  Future<Either<Failure, void>> execute(ProductEntity product) async {
    return await repository.updateProduct(product);
  }
}
