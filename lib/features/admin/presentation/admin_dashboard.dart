import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../auth/presentation/auth_providers.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: DesignSystem.textNavy,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
               ref.read(authControllerProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Manage School", style: DesignSystem.fontHeader),
                IconButton(
                  onPressed: () => ref.read(authControllerProvider.notifier).logout(),
                  icon: const Icon(Icons.logout, color: Colors.red),
                  tooltip: "Logout",
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _AdminActionCard(
                  icon: Icons.meeting_room,
                  title: "Classes",
                  color: Colors.purple,
                  onTap: () => context.push('/admin/classes'),
                ),
                _AdminActionCard(
                  icon: Icons.class_,
                  title: "Sections",
                  color: Colors.blue,
                  onTap: () => context.push('/admin/sections'),
                ),
                _AdminActionCard(
                  icon: Icons.people,
                  title: "Teachers",
                  color: Colors.orange,
                  onTap: () => context.push('/admin/teachers'),
                ),
                _AdminActionCard(
                  icon: Icons.face,
                  title: "Students",
                  color: Colors.green,
                  onTap: () => context.push('/admin/students'),
                ),
                _AdminActionCard(
                  icon: Icons.family_restroom,
                  title: "Parents",
                  color: Colors.teal,
                  onTap: () {
                     // TODO: Navigate to Parent Mgmt
                  },
                ),
                 _AdminActionCard(
                  icon: Icons.bar_chart,
                  title: "Reports",
                  color: Colors.redAccent,
                  onTap: () {
                     // TODO: Navigate to Reports
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _AdminActionCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: DesignSystem.fontTitle.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
