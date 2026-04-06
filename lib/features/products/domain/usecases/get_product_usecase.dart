import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductUsecase {
  final ProductRepository repository;

  GetProductUsecase(this.repository);

  Future<Either<Failure, ProductEntity>> execute(String id) {
    return repository.getProduct(id);
  }
}
