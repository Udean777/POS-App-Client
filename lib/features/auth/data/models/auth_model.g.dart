// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  email: json['email'] as String,
  businessId: json['business_id'] as String,
  businessName: json['business_name'] as String? ?? '',
  businessType: json['business_type'] as String? ?? '',
  businessAddress: json['business_address'] as String? ?? '',
  businessPhone: json['business_phone'] as String? ?? '',
  businessLogoUrl: json['business_logo_url'] as String? ?? '',
  role: json['role'] as String? ?? 'UNSET',
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'business_id': instance.businessId,
      'business_name': instance.businessName,
      'business_type': instance.businessType,
      'business_address': instance.businessAddress,
      'business_phone': instance.businessPhone,
      'business_logo_url': instance.businessLogoUrl,
      'role': instance.role,
    };
