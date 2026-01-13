import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/go_router_refresh_stream.dart';
import '../features/auth/domain/user_entity.dart';
import '../features/auth/presentation/auth_providers.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_shell.dart';
import '../features/dashboard/presentation/home_screen.dart';
import '../features/admin/presentation/admin_dashboard.dart';
import '../features/admin/presentation/section_management_screen.dart';
import '../features/admin/presentation/class_management_screen.dart';
import '../features/admin/presentation/teacher_management_screen.dart';
import '../features/admin/presentation/student_management_screen.dart';

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
        if (authState.value!.role == UserRole.admin) {
           print('REDIRECT: Admin logged in, going to /admin');
           return '/admin';
        }
        print('REDIRECT: Logged in, going to /home');
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
        builder: (context, state) => const LoginScreen(),
      ),
      // --- Admin Routes ---
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
        routes: [
          GoRoute(
            path: 'classes',
            builder: (context, state) => const ClassManagementScreen(),
          ),
          GoRoute(
            path: 'sections',
            builder: (context, state) => const SectionManagementScreen(),
          ),
          GoRoute(
            path: 'teachers',
            builder: (context, state) => const TeacherManagementScreen(),
          ),
          GoRoute(
            path: 'students',
            builder: (context, state) => const StudentManagementScreen(),
          ),
        ],
      ),
      // --- Parent/Other Routes ---
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const Scaffold(body: Center(child: Text("Calendar Mock"))),
      ),
      GoRoute(
        path: '/gallery',
        builder: (context, state) => const Scaffold(body: Center(child: Text("Gallery Mock"))),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const Scaffold(body: Center(child: Text("Profile Mock"))),
      ),
    ],
  );
});
