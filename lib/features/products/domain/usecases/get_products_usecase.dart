import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetProductsUsecase {
  final ProductRepository repository;

  GetProductsUsecase({required this.repository});

  Future<Either<Failure, List<ProductEntity>>> execute() async {
    return await repository.getProducts();
  }
}
