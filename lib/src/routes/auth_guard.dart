import 'package:client/core/constants/route_constants.dart';
import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/auth_status_provider.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard {
  final Ref ref;

  AuthGuard(this.ref);

  String? redirect(BuildContext context, GoRouterState state) {
    final String location = state.matchedLocation;

    // Get the latest states dynamically without causing rebuild of the Router itself
    final authState = ref.read(authNotifierProvider);
    final authStatus = ref.read(isAuthenticatedProvider);

    // Check if the user is logged in
    final bool loggedIn = authState.maybeWhen(
      authenticated: () => true,
      orElse: () => authStatus.value ?? false,
    );

    // Explicitly check for OTP state to prevent it from being hijacked by initial state
    final bool isUnverified = authState.maybeWhen(
      unverified: (_) => true,
      orElse: () => false,
    );

    final bool isPublicArea =
        location == RoutePaths.login ||
        location == RoutePaths.register ||
        location == RoutePaths.otp ||
        location == RoutePaths.forgotPassword ||
        location == RoutePaths.resetPassword;

    // --- Debug Logs ---
    debugPrint(
      '[AuthGuard] Location: $location, LoggedIn: $loggedIn, Public: $isPublicArea, UnverifiedState: $isUnverified',
    );

    // --- Redirection Logic ---
    if (!loggedIn && !isPublicArea) {
      debugPrint('[AuthGuard] Redirecting to LOGIN');
      return RoutePaths.login;
    }

    if (loggedIn && isPublicArea) {
      debugPrint('[AuthGuard] Redirecting to DASHBOARD');
      return RoutePaths.dashboard;
    }

    return null;
  }
}
