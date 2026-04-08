import 'package:client/core/providers/core_providers.dart';
import 'package:client/features/staff/data/datasources/staff_remote_data_source.dart';
import 'package:client/features/staff/data/repositories/staff_repository_impl.dart';
import 'package:client/features/staff/domain/repositories/staff_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final staffRemoteDataSourceProvider = Provider<StaffRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return StaffRemoteDataSourceImpl(dio);
});

final staffRepositoryProviderOverride = Provider<StaffRepository>((ref) {
  final remoteDataSource = ref.watch(staffRemoteDataSourceProvider);
  return StaffRepositoryImpl(remoteDataSource: remoteDataSource);
});
