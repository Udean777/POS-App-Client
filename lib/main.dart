import 'package:client/features/auth/data/providers/auth_data_providers.dart';
import 'package:client/features/auth/domain/providers/auth_domain_providers.dart';
import 'package:client/features/staff/data/providers/staff_data_providers.dart';
import 'package:client/features/staff/domain/providers/staff_domain_providers.dart';
import 'package:client/features/store/data/providers/store_data_providers.dart';
import 'package:client/features/store/domain/providers/store_domain_providers.dart';
import 'package:client/src/routes/app_router.dart';
import 'package:client/src/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWith(
          (ref) => ref.watch(authRepositoryProviderOverride),
        ),
        staffRepositoryProvider.overrideWith(
          (ref) => ref.watch(staffRepositoryProviderOverride),
        ),
        storeRepositoryProvider.overrideWith(
          (ref) => ref.watch(storeRepositoryProviderOverride),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Modal POS',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
