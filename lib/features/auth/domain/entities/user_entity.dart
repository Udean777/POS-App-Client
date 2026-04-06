import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const UserEntity._();

  const factory UserEntity({
    required String id,
    required String email,
    required String businessId,
    @Default('') String businessName,
    @Default('') String businessType,
    @Default('') String businessAddress,
    @Default('UNSET') String role,
  }) = _UserEntity;
}
