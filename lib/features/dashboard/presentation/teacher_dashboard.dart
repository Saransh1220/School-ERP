import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../../core/widgets/role/teacher_checklist_tile.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Row
          Row(
            children: [
              _buildStatChip(context, Icons.people, '18/20 Present', ThemeFactory.teacherPrimary),
              const SizedBox(width: 12),
              _buildStatChip(context, Icons.medical_services, '2 Meds', ThemeFactory.teacherSecondary),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            'Action Required',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TeacherChecklistTile(
            title: 'Morning Attendance',
            subtitle: '2 students yet to arrive',
            isCompleted: false,
            onToggle: () {},
          ),
          TeacherChecklistTile(
            title: 'Upload Lunch Photos',
            isCompleted: false,
            onToggle: () {},
          ),
          
          const SizedBox(height: 24),
          Text(
            'Completed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TeacherChecklistTile(
            title: 'Welcome Circle',
            isCompleted: true,
            onToggle: () {},
          ),
          TeacherChecklistTile(
            title: 'Check Safety Gate',
            isCompleted: true,
            onToggle: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(BuildContext context, IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[700], size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
