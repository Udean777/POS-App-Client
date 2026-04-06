import 'package:client/core/providers/core_providers.dart';
import 'package:client/features/products/data/datasources/product_remote_data_source.dart';
import 'package:client/features/products/data/repositories/product_repository_impl.dart';
import 'package:client/features/products/domain/repositories/product_repository.dart';
import 'package:client/features/products/domain/usecases/add_product_usecase.dart';
import 'package:client/features/products/domain/usecases/get_products_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_providers.g.dart';

@riverpod
ProductRemoteDataSource productRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ProductRemoteDataSourceImpl(dio);
}

@riverpod
ProductRepository productRepository(Ref ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
}

@riverpod
GetProductsUsecase getProductsUsecase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUsecase(repository: repository);
}

@riverpod
AddProductUsecase addProductUsecase(Ref ref) {
  final repository = ref.watch(productRepositoryProvider);
  return AddProductUsecase(repository);
}
