import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../config/design_system.dart';

class NavPill extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const NavPill({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea( // Ensure it respects bottom notch
        minimum: const EdgeInsets.only(bottom: 24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            boxShadow: DesignSystem.softLift,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.white.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _NavItem(
                      icon: Icons.history_edu_rounded,
                      label: 'Story',
                      isSelected: selectedIndex == 0,
                      onTap: () => onDestinationSelected(0),
                      color: DesignSystem.parentBlue,
                    ),
                    const SizedBox(width: 24),
                    _NavItem(
                      icon: Icons.photo_library_rounded,
                      label: 'Gallery',
                      isSelected: selectedIndex == 1,
                      onTap: () => onDestinationSelected(1),
                      color: DesignSystem.parentPeach,
                    ),
                    const SizedBox(width: 24),
                    _NavItem(
                      icon: Icons.person_rounded,
                      label: 'Profile',
                      isSelected: selectedIndex == 2,
                      onTap: () => onDestinationSelected(2),
                      color: DesignSystem.teacherYellow,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? color : DesignSystem.textSecondary,
          size: 28,
        ),
      ),
    );
  }
}
