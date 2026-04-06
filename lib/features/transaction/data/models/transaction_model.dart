import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:client/features/transaction/domain/entities/transaction_entity.dart';
import 'package:client/features/transaction/data/models/transaction_item_model.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'staff_id') required String staffId,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'amount_paid') required double amountPaid,
    @JsonKey(name: 'change') required double change,
    @JsonKey(name: 'payment_method') required String paymentMethod,
    required String status,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    Map<String, dynamic>? staff,
    @Default([]) List<TransactionItemModel> items,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
}

extension TransactionModelX on TransactionModel {
  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    businessId: businessId,
    staffId: staffId,
    staffEmail: staff?['email'], // get email from relation
    items: items.map((e) => e.toEntity()).toList(),
    totalAmount: totalAmount,
    amountPaid: amountPaid,
    change: change,
    paymentMethod: paymentMethod,
    status: status,
    createdAt: createdAt,
  );
}
