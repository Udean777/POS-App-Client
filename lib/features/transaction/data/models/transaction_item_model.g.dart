// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionItemModel _$TransactionItemModelFromJson(
  Map<String, dynamic> json,
) => _TransactionItemModel(
  id: json['id'] as String,
  transactionId: json['transaction_id'] as String,
  productId: json['product_id'] as String,
  variantId: json['variant_id'] as String,
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  subtotal: (json['subtotal'] as num).toDouble(),
  product: json['product'] as Map<String, dynamic>?,
  variant: json['variant'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$TransactionItemModelToJson(
  _TransactionItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'transaction_id': instance.transactionId,
  'product_id': instance.productId,
  'variant_id': instance.variantId,
  'quantity': instance.quantity,
  'price': instance.price,
  'subtotal': instance.subtotal,
  'product': instance.product,
  'variant': instance.variant,
};
