import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/auth_status_provider.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:client/features/auth/presentation/screens/login_screen.dart';
import 'package:client/features/auth/presentation/screens/register_screen.dart';
import 'package:client/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:client/features/products/presentation/screens/add_product_screen.dart';
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
      // ==========================================
      // PUBLIC ROUTES (Bisa diakses tanpa login)
      // ==========================================
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

      // ==========================================
      // AUTH GUARDED ROUTES (Wajib Login)
      // ==========================================
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
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
    ],
  );
}
