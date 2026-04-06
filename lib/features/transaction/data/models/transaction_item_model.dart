import 'package:client/features/transaction/domain/entities/transaction_item_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_item_model.freezed.dart';
part 'transaction_item_model.g.dart';

@freezed
abstract class TransactionItemModel with _$TransactionItemModel {
  const factory TransactionItemModel({
    required String id,
    @JsonKey(name: 'transaction_id') required String transactionId,
    @JsonKey(name: 'product_id') required String productId,
    @JsonKey(name: 'variant_id') required String variantId,
    required int quantity,
    required double price,
    required double subtotal,
    // Add product/variant relation from API
    Map<String, dynamic>? product,
    Map<String, dynamic>? variant,
  }) = _TransactionItemModel;

  factory TransactionItemModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionItemModelFromJson(json);
}

extension TransactionItemModelX on TransactionItemModel {
  TransactionItemEntity toEntity() => TransactionItemEntity(
    id: id,
    quantity: quantity,
    productName: product?['name'] ?? 'Unknown Product',
    variantName: variant?['name'] ?? 'Unknown Variant',
    price: price,
    subtotal: subtotal,
  );
}
