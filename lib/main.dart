import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'features/auth/presentation/auth_providers.dart';
import 'features/auth/domain/user_entity.dart';

void main() {
  runApp(const ProviderScope(child: SchoolApp()));
}

class SchoolApp extends ConsumerWidget {
  const SchoolApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final authState = ref.watch(authStateChangesProvider);
    final user = authState.value;

    return MaterialApp.router(
      title: 'School LMS',
      theme: user != null 
          ? ThemeFactory.getThemeForRole(user.role)
          : ThemeFactory.getThemeForRole(UserRole.parent), // Default
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
