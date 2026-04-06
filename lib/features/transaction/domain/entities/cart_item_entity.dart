import 'package:client/features/products/domain/entities/product_entity.dart';

class CartItemEntity {
  final ProductEntity product;
  final VariantEntity variant;
  int quantity;

  CartItemEntity({
    required this.product,
    required this.variant,
    this.quantity = 1,
  });

  double get subtotal => variant.price * quantity;

  String get id => '${product.id}_${variant.id}';
}
