import 'package:client/features/store/domain/repositories/store_repository.dart';
import 'package:client/features/store/domain/usecases/update_business_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  throw UnimplementedError();
});

final updateBusinessUsecaseProvider = Provider((ref) {
  final repository = ref.watch(storeRepositoryProvider);
  return UpdateBusinessUsecase(repository);
});
