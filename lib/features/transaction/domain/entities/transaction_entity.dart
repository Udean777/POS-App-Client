import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:client/features/transaction/domain/entities/transaction_item_entity.dart';

part 'transaction_entity.freezed.dart';

@freezed
abstract class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    required String id,
    required String businessId,
    required String staffId,
    String? staffEmail,
    @Default([]) List<TransactionItemEntity> items,
    required double totalAmount,
    required double amountPaid,
    required double change,
    required String paymentMethod,
    required String status,
    required DateTime createdAt,
  }) = _TransactionEntity;
}
