import 'package:client/core/constants/route_constants.dart';
import 'package:client/features/auth/presentation/providers/auth_notifier.dart';
import 'package:client/features/auth/presentation/providers/auth_status_provider.dart';
import 'package:client/features/staff/presentation/screens/add_staff_screen.dart';
import 'package:client/features/auth/presentation/screens/login_screen.dart';
import 'package:client/features/profile/presentation/screens/profile_screen.dart';
import 'package:client/features/auth/presentation/screens/register_screen.dart';
import 'package:client/features/staff/presentation/screens/staff_list_screen.dart';
import 'package:client/features/store/presentation/screens/store_config_screen.dart';
import 'package:client/features/dashboard/presentation/screens/all_menu_screen.dart';
import 'package:client/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:client/features/main/presentation/screens/main_screen.dart';
import 'package:client/features/products/domain/entities/product_entity.dart';
import 'package:client/features/products/presentation/screens/add_product_screen.dart';
import 'package:client/features/products/presentation/screens/edit_product_screen.dart';
import 'package:client/features/products/presentation/screens/product_detail_screen.dart';
import 'package:client/features/products/presentation/screens/product_list_screen.dart';
import 'package:client/features/transaction/presentation/screens/pos_screen.dart';
import 'package:client/features/transaction/presentation/screens/transaction_history_screen.dart';
import 'package:client/src/routes/app_page_transitions.dart';
import 'package:client/src/routes/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// A notifier that triggers a refresh in [GoRouter] when auth state changes.
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  RouterNotifier(this._ref) {
    _ref.listen(authNotifierProvider, (_, _) => notifyListeners());
    _ref.listen(isAuthenticatedProvider, (_, _) => notifyListeners());
  }
}

@riverpod
GoRouter goRouter(Ref ref) {
  final authState = ref.watch(authNotifierProvider);
  final authStatus = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: RoutePaths.dashboard,
    refreshListenable: RouterNotifier(ref),
    redirect: (context, state) => AuthGuard(
      authState: authState,
      authStatus: authStatus,
    ).redirect(context, state),
    routes: [
      // --- Auth Routes (fade transition) ---
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        pageBuilder: (context, state) =>
            AppPageTransitions.fade(state: state, child: const LoginScreen()),
      ),
      GoRoute(
        path: RoutePaths.register,
        name: RouteNames.register,
        pageBuilder: (context, state) => AppPageTransitions.slideRight(
          state: state,
          child: const RegisterScreen(),
        ),
      ),

      // --- Main Application Shell (Bottom Navigation) ---
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.dashboard,
                name: RouteNames.dashboard,
                pageBuilder: (context, state) => AppPageTransitions.fade(
                  state: state,
                  child: const DashboardScreen(),
                ),
              ),
            ],
          ),
          // Branch 1: POS
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.pos,
                name: RouteNames.pos,
                pageBuilder: (context, state) => AppPageTransitions.scaleUp(
                  state: state,
                  child: const PosScreen(),
                ),
              ),
            ],
          ),
          // Branch 2: Produk
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.products,
                name: RouteNames.products,
                pageBuilder: (context, state) => AppPageTransitions.slideRight(
                  state: state,
                  child: const ProductListScreen(),
                ),
              ),
            ],
          ),
          // Branch 3: Riwayat
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.history,
                name: RouteNames.history,
                pageBuilder: (context, state) => AppPageTransitions.slideRight(
                  state: state,
                  child: const TransactionHistoryScreen(),
                ),
              ),
            ],
          ),
          // Branch 4: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                pageBuilder: (context, state) => AppPageTransitions.fade(
                  state: state,
                  child: const ProfileScreen(),
                ),
              ),
            ],
          ),
        ],
      ),

      // --- Store Config & Management (slideUp for modal-like screens) ---
      GoRoute(
        path: RoutePaths.storeConfig,
        name: RouteNames.storeConfig,
        pageBuilder: (context, state) => AppPageTransitions.slideUp(
          state: state,
          child: const StoreConfigScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.staff,
        name: RouteNames.staff,
        pageBuilder: (context, state) => AppPageTransitions.slideRight(
          state: state,
          child: const StaffListScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.addStaff,
        name: RouteNames.addStaff,
        pageBuilder: (context, state) => AppPageTransitions.slideUp(
          state: state,
          child: const AddStaffScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.allMenu,
        name: RouteNames.allMenu,
        pageBuilder: (context, state) => AppPageTransitions.slideRight(
          state: state,
          child: const AllMenuScreen(),
        ),
      ),

      // --- Product Management (Details and Forms stay outside shell) ---
      GoRoute(
        path: RoutePaths.addProduct,
        name: RouteNames.addProduct,
        pageBuilder: (context, state) => AppPageTransitions.slideUp(
          state: state,
          child: const AddProductScreen(),
        ),
      ),
      GoRoute(
        path: RoutePaths.productDetail,
        name: RouteNames.productDetail,
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return AppPageTransitions.slideRight(
            state: state,
            child: ProductDetailScreen(productId: id),
          );
        },
      ),
      GoRoute(
        path: RoutePaths.editProduct,
        name: RouteNames.editProduct,
        pageBuilder: (context, state) {
          final product = state.extra as ProductEntity;
          return AppPageTransitions.slideUp(
            state: state,
            child: EditProductScreen(product: product),
          );
        },
      ),
    ],
  );
}
