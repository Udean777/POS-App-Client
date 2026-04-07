import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'product_providers.dart';
import 'product_list_notifier.dart';

part 'product_actions_notifier.g.dart';

@riverpod
class ProductActions extends _$ProductActions {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  /// Fungsi untuk Tambah Produk
  Future<void> addProduct(ProductEntity product) async {
    state = const AsyncValue.loading();

    final usecase = ref.read(addProductUsecaseProvider);
    final result = await usecase.execute(product);
    if (!ref.mounted) return;

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        ref.read(productListProvider.notifier).refresh();
      },
    );
  }

  /// Fungsi untuk Update Produk
  Future<void> updateProduct(ProductEntity product) async {
    state = const AsyncValue.loading();

    final usecase = ref.read(updateProductUsecaseProvider);
    final result = await usecase.execute(product);
    if (!ref.mounted) return;

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        ref.read(productListProvider.notifier).refresh();
      },
    );
  }

  /// Fungsi untuk Hapus Produk
  Future<void> deleteProduct(String id) async {
    state = const AsyncValue.loading();

    final usecase = ref.read(deleteProductUsecaseProvider);
    final result = await usecase.execute(id);
    if (!ref.mounted) return;

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        ref.read(productListProvider.notifier).refresh();
      },
    );
  }

  Future<void> restockVariant(String variantId, int quantity) async {
    state = const AsyncValue.loading();

    final usecase = ref.read(restockVariantUsecaseProvider);
    final result = await usecase.call(variantId, quantity); // wait, in usecases it's usually `execute` or `call`. I defined `call`
    if (!ref.mounted) return;

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = const AsyncValue.data(null);
        ref.read(productListProvider.notifier).refresh();
      },
    );
  }

  /// Fungsi untuk Upload Gambar
  Future<String?> uploadImage(String filePath) async {
    final usecase = ref.read(uploadImageUsecaseProvider);
    final result = await usecase.execute(filePath);

    return result.fold(
      (failure) {
        state = AsyncValue.error(failure.message, StackTrace.current);
        return null;
      },
      (url) => url,
    );
  }
}
