import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/providers/product_list_notifier.dart';
import 'package:client/features/products/presentation/providers/product_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'add_product_notifier.g.dart';

@riverpod
class AddProductNotifier extends _$AddProductNotifier {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> addProduct(ProductEntity product) async {
    state = const AsyncValue.loading();

    final usecase = ref.read(addProductUsecaseProvider);
    final result = await usecase.execute(product);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        ref.read(productListProvider.notifier).refresh();
      },
    );
  }
}
