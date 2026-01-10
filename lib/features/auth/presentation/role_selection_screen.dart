import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import 'auth_providers.dart';
import '../domain/user_entity.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the login state to show loading
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: DesignSystem.iceWhite,
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DesignSystem.parentTeal.withValues(alpha: 0.1),
              ),
            ).animate().fadeIn(duration: 1000.ms).scale(begin: const Offset(0.8, 0.8)),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: DesignSystem.parentOrange.withValues(alpha: 0.1),
              ),
            ).animate().fadeIn(duration: 1200.ms).scale(begin: const Offset(0.8, 0.8)),
          ),
          
          // Blur Overlay
           Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: const SizedBox(),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Header
                  Column(
                    children: [
                       Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: DesignSystem.glowShadow,
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 64,
                          color: DesignSystem.parentTeal,
                        ),
                      ).animate().scale(duration: 800.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome to\nKinderGuard',
                        style: DesignSystem.fontHeader.copyWith(
                          fontSize: 32,
                          color: DesignSystem.textNavy,
                          height: 1.1,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                      const SizedBox(height: 12),
                      Text(
                        'Choose your profile to sign in',
                        style: DesignSystem.fontBody.copyWith(
                          color: DesignSystem.textGreyBlue,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ),
                  const SizedBox(height: 60),
                  
                  if (state.isLoading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    _RoleCard(
                      title: 'Parent',
                      subtitle: 'Daily updates & Journal',
                      icon: Icons.family_restroom_rounded,
                      color: DesignSystem.parentTeal,
                      delay: 600.ms,
                      onTap: () => ref.read(authControllerProvider.notifier).login(UserRole.parent),
                    ),
                    const SizedBox(height: 16),
                    _RoleCard(
                      title: 'Teacher',
                      subtitle: 'Manage class & activities',
                      icon: Icons.auto_stories_rounded,
                      color: DesignSystem.parentOrange,
                      delay: 700.ms,
                      onTap: () => ref.read(authControllerProvider.notifier).login(UserRole.teacher),
                    ),
                    const SizedBox(height: 16),
                    _RoleCard(
                      title: 'Admin',
                      subtitle: 'School administration',
                      icon: Icons.admin_panel_settings_rounded,
                      color: DesignSystem.parentDeepTeal, // Darker Teal for Admin
                      delay: 800.ms,
                      onTap: () => ref.read(authControllerProvider.notifier).login(UserRole.admin),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Duration delay;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DesignSystem.fontTitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: DesignSystem.fontSmall.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, size: 16, color: DesignSystem.textGreyBlue.withValues(alpha: 0.5)),
        ],
      ),
    ).animate().fadeIn(delay: delay).slideX(begin: 0.2, end: 0);
  }
}
