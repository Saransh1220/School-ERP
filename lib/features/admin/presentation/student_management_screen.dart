import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../domain/user_entities.dart';
import '../domain/school_entities.dart';
import 'admin_providers.dart';

class StudentManagementScreen extends ConsumerWidget {
  const StudentManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studentsAsync = ref.watch(studentsProvider);
    final classesAsync = ref.watch(classesProvider);
    final sectionsAsync = ref.watch(sectionsProvider);

    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      appBar: AppBar(title: const Text("Manage Students")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddStudentDialog(context, ref, classesAsync.value ?? [], sectionsAsync.value ?? []),
        child: const Icon(Icons.person_add),
      ),
      body: studentsAsync.when(
        data: (students) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            
            // Resolve Section Name
            final sectionName = sectionsAsync.value
                ?.firstWhere((s) => s.id == student.sectionId, orElse: () => const Section(id: '', classId: '', name: 'Unknown'))
                .name ?? 'Unknown';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: AppCard(
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundImage: student.profilePhotoUrl != null ? NetworkImage(student.profilePhotoUrl!) : null,
                    child: student.profilePhotoUrl == null ? const Icon(Icons.face) : null,
                  ),
                  title: Text(student.fullName, style: DesignSystem.fontTitle),
                  subtitle: Text("Class: $sectionName | Parents: ${student.parentIds.length}"),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoRow(label: "Admission #", value: student.admissionNumber),
                          _InfoRow(label: "Emergency Contact", value: student.emergencyContact),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.link),
                                label: const Text("Link Parent (Manual)"),
                                onPressed: () => _showLinkParentDialog(context, ref, student.id),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
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

  void _showAddStudentDialog(BuildContext context, WidgetRef ref, List<Classroom> classes, List<Section> allSections) {
    final nameController = TextEditingController();
    final admissionController = TextEditingController();
    final parentNameController = TextEditingController();
    final parentPhoneController = TextEditingController();
    
    // State for dropdowns
    String? selectedClassId;
    String? selectedSectionId;
    String gender = 'Male'; // Default
    DateTime dob = DateTime.now().subtract(const Duration(days: 365 * 4)); // Default ~4 years old

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool isLoading = false;
          String? errorMessage;
          
          // Filter sections based on selected class
          final filteredSections = selectedClassId == null 
              ? <Section>[] 
              : allSections.where((s) => s.classId == selectedClassId).toList();

          return StatefulBuilder(
            builder: (context, innerSetState) {
              return AlertDialog(
                title: const Text("Register Student"),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Student Info", style: TextStyle(fontWeight: FontWeight.bold, color: DesignSystem.adminNavy)),
                      TextField(controller: nameController, decoration: const InputDecoration(labelText: "Full Name *", prefixIcon: Icon(Icons.person))),
                      const SizedBox(height: 8),
                      TextField(controller: admissionController, decoration: const InputDecoration(labelText: "Admission Number", prefixIcon: Icon(Icons.numbers))),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: gender,
                              decoration: const InputDecoration(labelText: "Gender"),
                              items: ['Male', 'Female'].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                              onChanged: (val) => innerSetState(() => gender = val!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: dob,
                                  firstDate: DateTime(2015),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) innerSetState(() => dob = picked);
                              },
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: "DOB", suffixIcon: Icon(Icons.calendar_today)),
                                child: Text("${dob.year}-${dob.month}-${dob.day}"),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedClassId,
                        decoration: const InputDecoration(labelText: "Class *", prefixIcon: Icon(Icons.class_)),
                        items: classes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),
                        onChanged: (val) {
                          innerSetState(() {
                            selectedClassId = val;
                            selectedSectionId = null; // Reset section
                          });
                        },
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedSectionId,
                        decoration: const InputDecoration(labelText: "Section *", prefixIcon: Icon(Icons.meeting_room)),
                        items: filteredSections.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                        onChanged: selectedClassId == null ? null : (val) {
                          innerSetState(() {
                            selectedSectionId = val;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text("Parent/Guardian Info", style: TextStyle(fontWeight: FontWeight.bold, color: DesignSystem.adminNavy)),
                      const Text("Used for Login & Emergency Contact", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 8),
                      TextField(controller: parentNameController, decoration: const InputDecoration(labelText: "Parent Name *", prefixIcon: Icon(Icons.person_outline))),
                      const SizedBox(height: 8),
                      TextField(
                         controller: parentPhoneController, 
                         decoration: const InputDecoration(
                           labelText: "Mobile Number * (Login ID)",
                           helperText: "Format: +1234567890",
                           prefixIcon: Icon(Icons.phone),
                         ),
                         keyboardType: TextInputType.phone,
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: isLoading ? null : () => Navigator.pop(context), child: const Text("Cancel")),
                  ElevatedButton(
                    onPressed: isLoading ? null : () async {
                      final name = nameController.text.trim();
                      final pName = parentNameController.text.trim();
                      final pPhone = parentPhoneController.text.trim();
                      
                      if (name.isNotEmpty && selectedClassId != null && selectedSectionId != null && pName.isNotEmpty && pPhone.isNotEmpty) {
                         innerSetState(() { isLoading = true; errorMessage = null; });
                         
                         final newStudent = Student(
                           id: '', 
                           fullName: name,
                           dob: dob,
                           gender: gender,
                           bloodGroup: "",
                           allergies: "",
                           emergencyContact: pPhone, // Key Link
                           admissionNumber: admissionController.text,
                           classId: selectedClassId!,
                           sectionId: selectedSectionId!,
                           parentIds: [], // Linked via Repo
                           createdAt: DateTime.now(),
                         );
                         
                         try {
                             await ref.read(adminRepositoryProvider).createStudent(
                               student: newStudent,
                               parentName: pName,
                               parentPhone: pPhone,
                             );
                             if (context.mounted) Navigator.pop(context);
                         } catch (e) {
                             if (context.mounted) {
                                innerSetState(() {
                                   isLoading = false;
                                   errorMessage = e.toString().replaceAll("Exception: ", "");
                                });
                             }
                         }
                      } else {
                         innerSetState(() => errorMessage = "Please fill all required fields (*)");
                      }
                    },
                    child: isLoading 
                       ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                       : const Text("Create Student"),
                  ),
                ],
              );
            }
          );
        }
      ),
    );
  }

  void _showLinkParentDialog(BuildContext context, WidgetRef ref, String studentId) {
    final parentUidController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Link Parent (Manual)"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Enter the Parent's UID (from Firebase Console/Auth):"),
            TextField(controller: parentUidController, decoration: const InputDecoration(labelText: "Parent UID")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final parentUid = parentUidController.text.trim();
              if (parentUid.isNotEmpty) {
                await ref.read(adminRepositoryProvider).linkParentToStudent(
                  parentUid: parentUid,
                  studentId: studentId,
                );
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text("Link"),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          Text(value, style: DesignSystem.fontBody),
        ],
      ),
    );
  }
}
