import 'package:flutter/material.dart';

class TeacherChecklistTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final VoidCallback onToggle;

  const TeacherChecklistTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isCompleted ? Theme.of(context).primaryColor : Colors.grey.shade400,
                width: 2,
              ),
              color: isCompleted ? Theme.of(context).primaryColor : Colors.transparent,
            ),
            child: isCompleted
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : const Icon(null, size: 16), // Placeholder for size
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: Icon(Icons.drag_handle_rounded, color: Colors.grey.shade300),
      ),
    );
  }
}
