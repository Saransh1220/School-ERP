import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../../../core/widgets/v2/nav_pill.dart';

class TeacherHomeTaskBoard extends StatelessWidget {
  const TeacherHomeTaskBoard({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Slightly cooler grey for focus
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 120, bottom: 100, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAttendanceRing(),
                const SizedBox(height: 32),
                Text(
                  "Quick Actions",
                  style: DesignSystem.fontTitle,
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                _buildActionGrid(),
                 const SizedBox(height: 32),
                Text(
                   "Pending Tasks",
                   style: DesignSystem.fontTitle,
                ).animate().fadeIn(delay: 400.ms),
                 const SizedBox(height: 16),
                _buildTaskList(),
              ],
            ),
          ),
          
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassHeader(
              title: "Class 3B",
              subtitle: "24 STUDENTS",
              trailing: Icon(Icons.search, size: 28, color: DesignSystem.textMain),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: NavPill(
              selectedIndex: 0,
              onDestinationSelected: (i) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRing() {
    return AppCard(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            height: 100,
            width: 100,
            child: Stack(
              children: [
                const Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: 0.85,
                      backgroundColor: Color(0xFFE3F2FD),
                      valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.teacherBlue),
                      strokeWidth: 8,
                      strokeCap: StrokeCap.round,
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "20",
                        style: DesignSystem.fontHeader.copyWith(color: DesignSystem.teacherBlue),
                      ),
                      Text(
                        "/ 24",
                        style: DesignSystem.fontSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Attendance", style: DesignSystem.fontTitle),
                const SizedBox(height: 4),
                Text(
                  "4 students absent today.\nCheck messages.",
                  style: DesignSystem.fontBody.copyWith(color: DesignSystem.textSecondary, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 400.ms);
  }

  Widget _buildActionGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _ActionTile(
          icon: Icons.check_circle_outline_rounded,
          label: "Mark\nAttendance",
          color: DesignSystem.teacherBlue,
        ),
        _ActionTile(
          icon: Icons.add_a_photo_rounded,
          label: "Add\nPhotos",
          color: DesignSystem.teacherYellow,
        ),
        _ActionTile(
          icon: Icons.restaurant_menu_rounded,
          label: "Log\nMeals",
          color: DesignSystem.parentPeach,
        ),
        _ActionTile(
          icon: Icons.masks_rounded, // Using closest Material icon for "Health/Incidents"
          label: "Health\nCheck",
          color: DesignSystem.adminTeal,
        ),
      ],
    ).animate().slideY(begin: 0.1, end: 0, delay: 200.ms);
  }
  
  Widget _buildTaskList() {
    return Column(
      children: [
        _TaskTile(title: "Upload Lunch Menu", isDone: false),
        _TaskTile(title: "Approve 3 Absences", isDone: false),
        _TaskTile(title: "Prepare for Art Class", isDone: true),
      ],
    ).animate().slideY(begin: 0.1, end: 0, delay: 400.ms);
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionTile({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: DesignSystem.fontTitle.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final String title;
  final bool isDone;

  const _TaskTile({required this.title, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: DesignSystem.radiusM,
        boxShadow: DesignSystem.softLift, // Reused soft shadow
      ),
      child: Row(
        children: [
          Icon(
            isDone ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
            color: isDone ? DesignSystem.teacherBlue : DesignSystem.textSecondary,
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: DesignSystem.fontBody.copyWith(
              decoration: isDone ? TextDecoration.lineThrough : null,
              color: isDone ? DesignSystem.textSecondary : DesignSystem.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
