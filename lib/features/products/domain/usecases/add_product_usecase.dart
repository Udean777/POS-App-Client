import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class AddProductUsecase {
  final ProductRepository repository;

  AddProductUsecase(this.repository);

  Future<Either<Failure, void>> execute(ProductEntity product) async {
    if (product.variants.isEmpty) {
      return Left(Failure("Produk harus memiliki minimal satu varian"));
    }
    return await repository.addProduct(product);
  }
}
