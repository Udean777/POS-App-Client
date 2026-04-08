import 'package:client/core/errors/failure.dart';
import 'package:client/features/store/domain/repositories/store_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateBusinessUsecase {
  final StoreRepository repository;

  UpdateBusinessUsecase(this.repository);

  Future<Either<Failure, void>> execute({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  }) async {
    if (name.trim().isEmpty) {
      return Left(Failure('Nama bisnis tidak boleh kosong'));
    }
    return await repository.updateBusiness(
      name: name.trim(),
      type: type,
      address: address,
      phone: phone,
      logoUrl: logoUrl,
    );
  }
}
