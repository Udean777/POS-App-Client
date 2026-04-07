import 'package:client/core/constants/route_constants.dart';
import 'package:client/features/auth/presentation/providers/state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthGuard {
  final AuthState authState;
  final AsyncValue<bool> authStatus;

  AuthGuard({required this.authState, required this.authStatus});

  String? redirect(BuildContext context, GoRouterState state) {
    // Check if the user is logged in
    final bool loggedIn = authState.maybeWhen(
      authenticated: () => true,
      orElse: () => authStatus.value ?? false,
    );

    // Check if the user has explicitly logged out
    final bool isExplicitLogout = authState.maybeWhen(
      initial: () => true,
      orElse: () => false,
    );

    // Use a local variable to determine the final login state
    bool effectiveLoggedIn = loggedIn;
    
    // Logic to handle the bridge between the notifier state and the persistent storage state
    if (isExplicitLogout && !authStatus.isLoading && !(authStatus.value ?? false)) {
      effectiveLoggedIn = false;
    }

    final String location = state.matchedLocation;
    final bool isPublicArea = 
        location == RoutePaths.login || 
        location == RoutePaths.register;

    // Redirection logic
    if (!effectiveLoggedIn && !isPublicArea) {
      return RoutePaths.login;
    }

    if (effectiveLoggedIn && isPublicArea) {
      return RoutePaths.dashboard;
    }

    return null;
  }
}
