import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:client/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:client/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:client/features/auth/domain/usecases/login_usecase.dart';
import 'package:client/features/auth/domain/usecases/register_usecase.dart';
import 'package:client/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:client/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:client/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  throw UnimplementedError();
});

final loginUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUsecase(repository);
});

final registerUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(repository);
});

final getProfileUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetProfileUsecase(repository);
});

final verifyOTPUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return VerifyOTPUsecase(repository);
});

final resendOTPUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResendOTPUsecase(repository);
});

final forgotPasswordUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUsecase(repository);
});

final resetPasswordUsecaseProvider = Provider((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ResetPasswordUsecase(repository);
});
