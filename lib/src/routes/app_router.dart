import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/auth_status_provider.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:client/features/auth/presentation/screens/login_screen.dart';
import 'package:client/features/auth/presentation/screens/register_screen.dart';
import 'package:client/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// Helper class to notify GoRouter when auth state changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, __) => notifyListeners());
    _ref.listen(isAuthenticatedProvider, (_, __) => notifyListeners());
  }
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authNotifierState = ref.watch(authNotifierProvider);
  final authStatusAsync = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/login',
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
      if (authStatusAsync.isLoading && !authStatusAsync.hasValue) return null;

      if (isExplicitLogout &&
          !authStatusAsync.isLoading &&
          !(authStatusAsync.value ?? false)) {
        loggedIn = false;
      }

      final bool isLoggingIn = state.matchedLocation == '/login';
      final bool isRegistering = state.matchedLocation == '/register';

      if (!loggedIn) {
        return (isLoggingIn || isRegistering) ? null : '/login';
      }

      if (loggedIn && (isLoggingIn || isRegistering)) {
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
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
    ],
  );
}
