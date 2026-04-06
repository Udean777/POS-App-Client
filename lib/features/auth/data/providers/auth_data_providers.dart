import 'package:client/core/providers/core_providers.dart';
import 'package:client/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:client/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRemoteDataSourceImpl(dio);
});

final authRepositoryProviderOverride = Provider((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final storage = ref.watch(secureStorageProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    storage: storage,
  );
});
