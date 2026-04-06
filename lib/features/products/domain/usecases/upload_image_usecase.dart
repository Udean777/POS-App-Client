import 'package:client/core/errors/failure.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadImageUsecase {
  final ProductRepository repository;

  UploadImageUsecase(this.repository);

  Future<Either<Failure, String>> execute(String filePath) {
    return repository.uploadProductImage(filePath);
  }
}
