import 'package:client/core/constants/app_constants.dart';
import 'package:client/core/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_status_provider.g.dart';

@riverpod
Future<bool> isAuthenticated(Ref ref) async {
  final storage = ref.watch(secureStorageProvider);
  final token = await storage.read(key: AppConstants.tokenKey);

  return token != null;
}
