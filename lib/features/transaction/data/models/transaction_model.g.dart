// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    _TransactionModel(
      id: json['id'] as String,
      businessId: json['business_id'] as String,
      staffId: json['staff_id'] as String,
      totalAmount: (json['total_amount'] as num).toDouble(),
      amountPaid: (json['amount_paid'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      staff: json['staff'] as Map<String, dynamic>?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => TransactionItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TransactionModelToJson(_TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'staff_id': instance.staffId,
      'total_amount': instance.totalAmount,
      'amount_paid': instance.amountPaid,
      'change': instance.change,
      'payment_method': instance.paymentMethod,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'staff': instance.staff,
      'items': instance.items,
    };
