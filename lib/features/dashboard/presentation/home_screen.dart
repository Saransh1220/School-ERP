import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/domain/user_entity.dart';
import '../../auth/presentation/auth_providers.dart';
import 'v2/parent_home_story.dart';
import 'v2/teacher_home_taskboard.dart';
import '../../admin/presentation/admin_dashboard.dart';
import '../../parent/presentation/parent_shell.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).value;
    
    // Fallback if no user
    if (user == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    switch (user.role) {
      case UserRole.parent:
        return const ParentShell(); // Use the new Shell with Bottom Nav
      case UserRole.teacher:
        return const TeacherHomeTaskBoard();
      case UserRole.admin:
        return const AdminDashboardScreen();
    }
  }
}
