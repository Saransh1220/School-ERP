import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../../../core/widgets/v2/nav_pill.dart'; // Import NavPill

class ParentHomeStoryView extends StatelessWidget {
  const ParentHomeStoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.offWhite,
      extendBodyBehindAppBar: true,
      extendBody: true, // Allow body behind nav pill
      body: Stack(
        children: [
          // Content
          SingleChildScrollView(
            padding: EdgeInsets.only(top: 120, bottom: 100), // Space for header and nav
            child: Column(
              children: [
                _buildHeroCard(),
                const SizedBox(height: 32),
                _buildStoryTimeline(),
              ],
            ),
          ),
          
          // Floating Header
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassHeader(
              title: "Today's Story",
              subtitle: "WED, OCT 24",
              trailing: CircleAvatar(
                backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=L+S&background=81D4FA&color=fff'),
              ),
            ),
          ),

          // Floating Nav Pill (Demo only, normally controlled by Shell)
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

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AppCard(
        color: DesignSystem.parentPeach.withOpacity(0.3),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Text('😊', style: TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lisa is feeling Happy!",
                    style: DesignSystem.fontTitle.copyWith(color: DesignSystem.textMain),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Checked in at 8:45 AM",
                    style: DesignSystem.fontSmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fade().scale(duration: 400.ms);
  }

  Widget _buildStoryTimeline() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoryItem(
            time: '10:30 AM',
            title: 'Art Class Masterpiece',
            description: 'Lisa made a beautiful finger painting today! She loves using the blue color.',
            icon: Icons.palette_rounded,
            color: DesignSystem.parentBlue,
            image: "https://images.unsplash.com/photo-1596464716127-f9a804e0647e?auto=format&fit=crop&w=800&q=80",
          ),
          const SizedBox(height: 24),
          _buildStoryItem(
            time: '09:15 AM',
            title: 'Morning Snack',
            description: 'Ate all the apple slices and drank full water bottle.',
            icon: Icons.restaurant_rounded,
            color: DesignSystem.teacherYellow,
          ),
           const SizedBox(height: 24),
          _buildStoryItem(
            time: '08:45 AM',
            title: 'Drop Off',
            description: 'Arrived with a big smile. Said goodbye to Dad happily.',
            icon: Icons.door_front_door_rounded,
            color: DesignSystem.adminTeal,
          ),
        ],
      ),
    );
  }

  Widget _buildStoryItem({
    required String time,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    String? image,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line
          Column(
            children: [
              Text(
                time,
                style: DesignSystem.fontSmall.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.4), blurRadius: 8, spreadRadius: 2),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: 2,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.5), color.withOpacity(0.0)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Content Bubble
          Expanded(
            child: AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icon, color: color, size: 20),
                            const SizedBox(width: 8),
                            Text(title, style: DesignSystem.fontTitle.copyWith(fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(description, style: DesignSystem.fontBody),
                      ],
                    ),
                  ),
                  if (image != null)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                      child: Image.network(
                        image,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuart);
  }
}
