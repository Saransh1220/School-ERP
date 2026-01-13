import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../domain/school_entities.dart';
import 'admin_providers.dart';

class ClassManagementScreen extends ConsumerWidget {
  const ClassManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classesAsync = ref.watch(classesProvider);

    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      appBar: AppBar(title: const Text("Manage Classes")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClassDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: classesAsync.when(
        data: (classes) => classes.isEmpty 
            ? const Center(child: Text("No classes yet. Add one!"))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final classroom = classes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AppCard(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: DesignSystem.adminTeal.withValues(alpha: 0.1),
                          child: Text("${classroom.order}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        title: Text(classroom.name, style: DesignSystem.fontTitle),
                        subtitle: Text("Order: ${classroom.order}"),
                        trailing: const Icon(Icons.edit),
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

  void _showAddClassDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final orderController = TextEditingController(text: "1");
    
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
                  title: const Text("Add Class (e.g. Nursery)"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Class Name",
                          errorText: errorMessage,
                        ),
                        enabled: !isLoading,
                      ),
                       const SizedBox(height: 12),
                      TextField(
                        controller: orderController,
                        decoration: const InputDecoration(labelText: "Order (Sort Priority)"),
                        keyboardType: TextInputType.number,
                        enabled: !isLoading,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: isLoading ? null : () => Navigator.pop(context), 
                      child: const Text("Cancel")
                    ),
                    ElevatedButton(
                      onPressed: isLoading ? null : () async {
                        final name = nameController.text.trim();
                        final order = int.tryParse(orderController.text) ?? 1;
                        
                        if (name.isNotEmpty) {
                           innerSetState(() { 
                             isLoading = true; 
                             errorMessage = null; 
                           });
                           
                           final newClass = Classroom(id: '', name: name, order: order);
                           
                           try {
                               await ref.read(adminRepositoryProvider).createClassroom(newClass);
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
}
