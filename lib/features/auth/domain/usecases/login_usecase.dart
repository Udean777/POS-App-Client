import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, String>> execute({
    required String email,
    required String password,
  }) async {
    // 1. Validasi Email
    if (email.trim().isEmpty) {
      return Left(Failure('Email tidak boleh kosong'));
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return Left(Failure('Format email tidak valid (contoh: nama@toko.com)'));
    }

    // 2. Validasi Password
    if (password.isEmpty) {
      return Left(Failure('Password tidak boleh kosong'));
    }

    return await repository.login(
      email: email.trim(),
      password: password,
    );
  }
}

