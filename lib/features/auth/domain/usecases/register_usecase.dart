import 'package:client/core/errors/failure.dart';
import 'package:client/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, void>> execute({
    required String email,
    required String password,
    required String businessName,
  }) async {
    // 1. Validasi Nama Bisnis
    if (businessName.trim().isEmpty) {
      return Left(Failure('Nama bisnis tidak boleh kosong'));
    }
    if (businessName.trim().length < 3) {
      return Left(Failure('Nama bisnis minimal 3 karakter'));
    }

    // 2. Validasi Email
    if (email.trim().isEmpty) {
      return Left(Failure('Email tidak boleh kosong'));
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      return Left(Failure('Format email tidak valid (contoh: nama@toko.com)'));
    }

    // 3. Validasi Password
    if (password.isEmpty) {
      return Left(Failure('Password tidak boleh kosong'));
    }
    if (password.length < 8) {
      return Left(Failure('Password minimal 8 karakter agar lebih aman'));
    }

    return await repository.register(
      email: email.trim(),
      password: password,
      businessName: businessName.trim(),
    );
  }
}

