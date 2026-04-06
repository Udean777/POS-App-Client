import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_item_entity.freezed.dart';

@freezed
abstract class TransactionItemEntity with _$TransactionItemEntity {
  const factory TransactionItemEntity({
    required String id,
    required int quantity,
    required String productName,
    required String variantName,
    required double price,
    required double subtotal,
  }) = _TransactionItemEntity;
}
