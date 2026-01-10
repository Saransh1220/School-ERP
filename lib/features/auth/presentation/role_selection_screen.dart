import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/theme.dart';
import '../../../../core/widgets/role_tile.dart';
import 'auth_providers.dart';
import '../domain/user_entity.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the login state to show loading
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Header Animation
              Column(
                children: [
                   Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 5,
                        )
                      ]
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                  ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
                  const SizedBox(height: 24),
                  Text(
                    'Welcome to\nKinderGuard',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppTheme.primaryColor,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                  const SizedBox(height: 12),
                  Text(
                    'Choose your profile to sign in',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppTheme.textGrey,
                      fontWeight: FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
              const SizedBox(height: 60),
              
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                RoleTile(
                  title: 'Parent',
                  subtitle: 'View your child’s daily updates',
                  icon: Icons.family_restroom_rounded,
                  color: AppTheme.primaryColor,
                  delay: 600.ms,
                  onTap: () => ref.read(authControllerProvider.notifier).login(UserRole.parent),
                ),
                RoleTile(
                  title: 'Teacher',
                  subtitle: 'Manage class & activities',
                  icon: Icons.auto_stories_rounded,
                  color: AppTheme.secondaryColor,
                  delay: 700.ms,
                  onTap: () => ref.read(authControllerProvider.notifier).login(UserRole.teacher),
                ),
                RoleTile(
                  title: 'Admin',
                  subtitle: 'School administration',
                  icon: Icons.admin_panel_settings_rounded,
                  color: AppTheme.successColor,
                  delay: 800.ms,
                  onTap: () => ref.read(authControllerProvider.notifier).login(UserRole.admin),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
