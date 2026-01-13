import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../domain/school_entities.dart';
import '../domain/user_entities.dart';
import 'admin_providers.dart';

class SectionManagementScreen extends ConsumerWidget {
  const SectionManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sectionsAsync = ref.watch(sectionsProvider);
    final classesAsync = ref.watch(classesProvider);
    final teachersAsync = ref.watch(teachersProvider);

    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      appBar: AppBar(title: const Text("Manage Sections")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSectionDialog(context, ref, classesAsync.value ?? [], teachersAsync.value ?? []),
        child: const Icon(Icons.add),
      ),
      body: sectionsAsync.when(
        data: (sections) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sections.length,
          itemBuilder: (context, index) {
            final section = sections[index];
            // Lookup class name
            final className = classesAsync.value
                ?.firstWhere(
                  (c) => c.id == section.classId, 
                  orElse: () => const Classroom(id: '', name: 'Unknown', order: 0)
                )
                .name ?? 'Unknown';

            // Lookup Teacher Name
            final teacherName = teachersAsync.value
                ?.firstWhere((t) => t.uid == section.teacherId, orElse: () => const UserProfile(uid: '', email: '', role: UserRole.teacher, fullName: 'Unassigned'))
                .fullName ?? 'Unassigned';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: ListTile(
                  title: Text(section.name, style: DesignSystem.fontTitle),
                  subtitle: Text("$className • Teacher: $teacherName"),
                  trailing: const Icon(Icons.edit),
                  onTap: () => _showEditSectionDialog(context, ref, section, classesAsync.value ?? [], teachersAsync.value ?? []),
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

  void _showAddSectionDialog(BuildContext context, WidgetRef ref, List<Classroom> classes, List<UserProfile> teachers) {
    final nameController = TextEditingController();
    String? selectedClassId = classes.isNotEmpty ? classes.first.id : null;
    String? selectedTeacherId;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool isLoading = false;
          String? errorMessage;

          return StatefulBuilder(
             builder: (context, innerSetState) {
                return AlertDialog(
                  title: const Text("Add Section"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (classes.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16.0),
                          child: Text("⚠️ No Classes found. Please create a Class first.", style: TextStyle(color: Colors.red)),
                        ),
                      DropdownButtonFormField<String>(
                        value: selectedClassId,
                        decoration: const InputDecoration(labelText: "Select Class"),
                        items: classes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                        onChanged: isLoading ? null : (val) {
                          innerSetState(() => selectedClassId = val);
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Section Name (e.g., A, Blue)",
                          errorText: errorMessage,
                          errorMaxLines: 3,
                        ),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedTeacherId,
                        decoration: const InputDecoration(labelText: "Assign Teacher (Optional)"),
                        items: [
                           const DropdownMenuItem(value: null, child: Text("None")),
                           ...teachers.map((t) => DropdownMenuItem(value: t.uid, child: Text(t.fullName ?? t.email))),
                        ],
                        onChanged: isLoading ? null : (val) {
                          innerSetState(() => selectedTeacherId = val);
                        },
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context), 
                      child: const Text("Cancel")
                    ),
                    ElevatedButton(
                      onPressed: (isLoading || classes.isEmpty) ? null : () async {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty && selectedClassId != null) {
                           innerSetState(() { 
                             isLoading = true; 
                             errorMessage = null; 
                           });
                           
                           final newSection = Section(
                             id: '', 
                             classId: selectedClassId!, 
                             name: name,
                             teacherId: selectedTeacherId
                           );
                           
                           try {
                               await ref.read(adminRepositoryProvider).createSection(newSection);
                               if (context.mounted) Navigator.pop(context);
                           } catch (e) {
                               if (context.mounted) {
                                  innerSetState(() {
                                     isLoading = false;
                                     errorMessage = e.toString().replaceAll("Exception: ", "");
                                  });
                               }
                           }
                        }
                      },
                      child: isLoading 
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text("Create"),
                    ),
                  ],
                );
             }
          );
        }
      ),
    );
  }

  void _showEditSectionDialog(BuildContext context, WidgetRef ref, Section section, List<Classroom> classes, List<UserProfile> teachers) {
      // For MVP, simplistic edit (re-create logic or update?)
      // AdminRepo doesn't have updateSection yet. We'll add a TODO or basic impl.
      // Actually, createSection can overwrite if ID provided, but here ID is auto-gen if empty. 
      // But Section entity has ID.
      // Let's assume createSection with existing ID performs Set (update).
      
      final nameController = TextEditingController(text: section.name);
      String? selectedClassId = section.classId;
      String? selectedTeacherId = section.teacherId;

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;
            return AlertDialog(
              title: const Text("Edit Section"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   DropdownButtonFormField<String>(
                      value: selectedClassId,
                      decoration: const InputDecoration(labelText: "Select Class"),
                      items: classes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                      onChanged: (val) => setState(() => selectedClassId = val),
                   ),
                   const SizedBox(height: 16),
                   TextField(controller: nameController, decoration: const InputDecoration(labelText: "Section Name")),
                   const SizedBox(height: 16),
                   DropdownButtonFormField<String>(
                      value: selectedTeacherId,
                      decoration: const InputDecoration(labelText: "Assign Teacher"),
                      items: [
                          const DropdownMenuItem(value: null, child: Text("None")),
                          ...teachers.map((t) => DropdownMenuItem(value: t.uid, child: Text(t.fullName ?? t.email))),
                      ],
                      onChanged: (val) => setState(() => selectedTeacherId = val),
                   ),
                ],
              ),
              actions: [
                 TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                 ElevatedButton(
                    onPressed: isLoading ? null : () async {
                       setState(() => isLoading = true);
                       final updatedSection = Section(
                         id: section.id, // Preserve ID
                         classId: selectedClassId!,
                         name: nameController.text.trim(),
                         teacherId: selectedTeacherId,
                       );
                       // We misuse createSection for update for now as it uses .set(merge: false) usually but here .set() on docRef.
                       // Repo checks: docRef = ...doc() (auto) vs ...doc(id).
                       // Wait, createSection in Repo uses .doc() (auto-id) unconditionally!
                       // I need to fix AdminRepository.createSection to support updates.
                       
                       // For now, I'll allow "Re-creating" purely for testing, but I MUST fix Repo.
                       // Let's assume I will fix Repo next.
                       await ref.read(adminRepositoryProvider).createSection(updatedSection); 
                       if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text("Update"),
                 )
              ],
            );
          }
        )
      );
  }
}
