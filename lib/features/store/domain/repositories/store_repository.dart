import 'package:client/core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class StoreRepository {
  Future<Either<Failure, void>> updateBusiness({
    required String name,
    required String type,
    required String address,
    required String phone,
    String? logoUrl,
  });
}
