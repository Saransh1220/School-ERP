import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/nav_pill.dart';
import 'home/parent_home_screen.dart';
import 'stats/parent_stats_screen.dart';
import 'gallery/parent_gallery_screen.dart';
import 'profile/parent_profile_screen.dart';

class ParentShell extends ConsumerStatefulWidget {
  const ParentShell({super.key});

  @override
  ConsumerState<ParentShell> createState() => _ParentShellState();
}

class _ParentShellState extends ConsumerState<ParentShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ParentHomeScreen(),
    const ParentStatsScreen(),
    const ParentGalleryScreen(),
    const ParentProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.creamWhite, // Warm cream background
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      // Custom Floating Bottom Bar
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 24, left: 24, right: 24),
        child: NavPillV2(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}

// Customized NavPill for 4 items
class NavPillV2 extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const NavPillV2({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7), // Semi-transparent for blur
        borderRadius: BorderRadius.circular(50),
        boxShadow: DesignSystem.glowShadow, // Colored glow
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _NavItem(icon: Icons.history_edu_rounded, label: "Story", index: 0, selectedIndex: selectedIndex, onTap: onDestinationSelected),
                _NavItem(icon: Icons.insights_rounded, label: "Stats", index: 1, selectedIndex: selectedIndex, onTap: onDestinationSelected),
                _NavItem(icon: Icons.photo_library_rounded, label: "Gallery", index: 2, selectedIndex: selectedIndex, onTap: onDestinationSelected),
                _NavItem(icon: Icons.person_rounded, label: "Profile", index: 3, selectedIndex: selectedIndex, onTap: onDestinationSelected),
              ],
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
  final int index;
  final int selectedIndex;
  final Function(int) onTap;

  const _NavItem({required this.icon, required this.label, required this.index, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? DesignSystem.parentTeal : Colors.transparent, // Vibrant Teal
          borderRadius: BorderRadius.circular(16), // Squircle Shape
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : DesignSystem.textGreyBlue, // White Active Icon
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
