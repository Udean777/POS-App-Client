import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class RestockVariant {
  final ProductRepository repository;

  RestockVariant(this.repository);

  Future<Either<Failure, void>> call(String variantId, int quantity) {
    return repository.restockVariant(variantId, quantity);
  }
}
