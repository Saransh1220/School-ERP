import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/go_router_refresh_stream.dart';
import '../features/auth/domain/user_entity.dart';
import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/role_selection_screen.dart';
import '../features/dashboard/presentation/dashboard_shell.dart';
import '../features/dashboard/presentation/home_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Use a ValueNotifier that notifies when the auth state changes
  final authStateNotifier = ValueNotifier<void>(null);
  
  // Listen to the provider. Whenever it updates (Loading -> Data, Data -> Data), notify GoRouter.
  ref.listen<AsyncValue<UserEntity?>>(
    authStateChangesProvider,
    (_, __) => authStateNotifier.notifyListeners(),
  );

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authStateNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateChangesProvider);
      
      print('REDIRECT: Current Path: ${state.uri.toString()}');
      print('REDIRECT: Auth State: $authState');
      print('REDIRECT: isLoading: ${authState.isLoading}, hasUser: ${authState.value != null}');

      final isLoading = authState.isLoading;
      final hasUser = authState.value != null;
      final isSplash = state.uri.toString() == '/splash';
      final isLogin = state.uri.toString() == '/login';
      
      if (isLoading && !hasUser) {
        print('REDIRECT: Stuck in loading, returning /splash');
        return '/splash';
      }

      if (!isLoading && !hasUser) {
        print('REDIRECT: Not logged in, going to login');
        return isLogin ? null : '/login';
      }

      if (hasUser && (isLogin || isSplash)) {
        print('REDIRECT: Logged in, going to home');
        return '/home';
      }

      print('REDIRECT: No change');
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return DashboardShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calendar',
                builder: (context, state) => const Scaffold(body: Center(child: Text("Calendar Mock"))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/gallery',
                builder: (context, state) => const Scaffold(body: Center(child: Text("Gallery Mock"))),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const Scaffold(body: Center(child: Text("Profile Mock"))),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
