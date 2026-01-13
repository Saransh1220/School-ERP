import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../domain/user_entities.dart';
import 'admin_providers.dart';

class TeacherManagementScreen extends ConsumerWidget {
  const TeacherManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachersAsync = ref.watch(teachersProvider);

    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      appBar: AppBar(title: const Text("Manage Teachers")),
      // Removed FloatingActionButton because creating teachers requires Auth/Cloud Functions.
      // Can add later if we implement "Invite System".
      body: teachersAsync.when(
        data: (teachers) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: teachers.length,
          itemBuilder: (context, index) {
            final teacher = teachers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(teacher.fullName ?? 'Unknown', style: DesignSystem.fontTitle),
                  subtitle: Text(teacher.email),
                  trailing: const Icon(Icons.star_border), // Placeholder for actions
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
      ),
    );
  }
}
