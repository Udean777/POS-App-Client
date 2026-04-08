import 'package:client/core/providers/core_providers.dart';
import 'package:client/features/store/data/datasources/store_remote_data_source.dart';
import 'package:client/features/store/data/repositories/store_repository_impl.dart';
import 'package:client/features/store/domain/repositories/store_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storeRemoteDataSourceProvider = Provider<StoreRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return StoreRemoteDataSourceImpl(dio);
});

final storeRepositoryProviderOverride = Provider<StoreRepository>((ref) {
  final remoteDataSource = ref.watch(storeRemoteDataSourceProvider);
  return StoreRepositoryImpl(remoteDataSource: remoteDataSource);
});
