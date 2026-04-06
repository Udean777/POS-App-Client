import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/auth_status_provider.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:client/features/auth/presentation/screens/login_screen.dart';
import 'package:client/features/auth/presentation/screens/register_screen.dart';
import 'package:client/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:client/features/auth/presentation/screens/profile_screen.dart';
import 'package:client/features/auth/presentation/screens/staff_list_screen.dart';
import 'package:client/features/auth/presentation/screens/add_staff_screen.dart';
import 'package:client/features/main/presentation/screens/main_screen.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/screens/add_product_screen.dart';
import 'package:client/features/products/presentation/screens/edit_product_screen.dart';
import 'package:client/features/products/presentation/screens/product_detail_screen.dart';
import 'package:client/features/products/presentation/screens/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, _) => notifyListeners());
    _ref.listen(isAuthenticatedProvider, (_, _) => notifyListeners());
  }
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authNotifierState = ref.watch(authNotifierProvider);
  final authStatusAsync = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: RouterNotifier(ref),
    redirect: (context, state) {
      bool loggedIn = authNotifierState.maybeWhen(
        authenticated: () => true,
        orElse: () => authStatusAsync.value ?? false,
      );

      final bool isExplicitLogout = authNotifierState.maybeWhen(
        initial: () => true,
        orElse: () => false,
      );

      if (isExplicitLogout &&
          !authStatusAsync.isLoading &&
          !(authStatusAsync.value ?? false)) {
        loggedIn = false;
      }

      final String location = state.matchedLocation;
      final bool isPublicArea = location == '/login' || location == '/register';

      if (!loggedIn && !isPublicArea) {
        return '/login';
      }

      if (loggedIn && isPublicArea) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main Application Shell (Bottom Navigation)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      // Auth Management (Owner Only)
      GoRoute(
        path: '/staff',
        name: 'staff',
        builder: (context, state) => const StaffListScreen(),
      ),
      GoRoute(
        path: '/staff/add',
        name: 'add_staff',
        builder: (context, state) => const AddStaffScreen(),
      ),

      // Product Routes
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) => const ProductListScreen(),
      ),
      GoRoute(
        path: '/products/add',
        name: 'add_product',
        builder: (context, state) => const AddProductScreen(),
      ),
      GoRoute(
        path: '/products/:id',
        name: 'product_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ProductDetailScreen(productId: id);
        },
      ),
      GoRoute(
        path: '/products/:id/edit',
        name: 'edit_product',
        builder: (context, state) {
          final product = state.extra as ProductEntity;
          return EditProductScreen(product: product);
        },
      ),
    ],
  );
}
