import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/transaction/domain/entities/cart_item_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cart_provider.g.dart';

@riverpod
class CartNotifier extends _$CartNotifier {
  @override
  List<CartItemEntity> build() {
    return [];
  }

  void addItem(ProductEntity product, VariantEntity variant) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && item.variant.id == variant.id,
    );

    if (existingIndex >= 0) {
      final newState = List<CartItemEntity>.from(state);
      newState[existingIndex] = CartItemEntity(
        product: product,
        variant: variant,
        quantity: state[existingIndex].quantity + 1,
      );
      state = newState;
    } else {
      state = [...state, CartItemEntity(product: product, variant: variant)];
    }
  }

  void removeItem(String cartItemId) {
    state = state.where((item) => item.id != cartItemId).toList();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(cartItemId);
      return;
    }

    final newState = List<CartItemEntity>.from(state);
    final index = newState.indexWhere((item) => item.id == cartItemId);

    if (index >= 0) {
      newState[index] = CartItemEntity(
        product: newState[index].product,
        variant: newState[index].variant,
        quantity: newQuantity,
      );
      state = newState;
    }
  }

  void clearCart() {
    state = [];
  }

  double getTotalPrice() {
    return state.fold(0.0, (total, item) => total + item.subtotal);
  }

  int getTotalItems() {
    return state.fold(0, (total, item) => total + item.quantity);
  }
}
