import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_detail_provider.g.dart';

@riverpod
Future<ProductEntity> productDetail(Ref ref, String id) async {
  final getProductUsecase = ref.watch(getProductUsecaseProvider);
  final result = await getProductUsecase.execute(id);

  return result.fold((failure) => throw failure.message, (product) => product);
}
