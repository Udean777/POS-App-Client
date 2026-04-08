import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:client/features/auth/domain/entities/user_entity.dart';

part 'auth_model.freezed.dart';
part 'auth_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'business_id') required String businessId,
    @JsonKey(name: 'business_name') @Default('') String businessName,
    @JsonKey(name: 'business_type') @Default('') String businessType,
    @JsonKey(name: 'business_address') @Default('') String businessAddress,
    @JsonKey(name: 'business_phone') @Default('') String businessPhone,
    @JsonKey(name: 'business_logo_url') @Default('') String businessLogoUrl,
    @Default('UNSET') String role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() => UserEntity(
    id: id,
    email: email,
    businessId: businessId,
    businessName: businessName,
    businessType: businessType,
    businessAddress: businessAddress,
    businessPhone: businessPhone,
    businessLogoUrl: businessLogoUrl,
    role: role,
  );
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;

  LoginResponse({required this.accessToken, required this.refreshToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
    );
  }
}
