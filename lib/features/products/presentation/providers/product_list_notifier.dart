import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'product_list_notifier.g.dart';

@riverpod
class ProductListNotifier extends _$ProductListNotifier {
  @override
  Future<List<ProductEntity>> build() async {
    return _fetchProducts();
  }

  Future<List<ProductEntity>> _fetchProducts() async {
    final usecase = ref.read(getProductsUsecaseProvider);
    final result = await usecase.execute();

    return result.fold(
      (failure) => throw failure.message,
      (products) => products,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProducts());
  }
}
