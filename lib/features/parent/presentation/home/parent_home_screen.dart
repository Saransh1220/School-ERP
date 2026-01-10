import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../data/parent_mock_data.dart';

class ParentHomeScreen extends StatelessWidget {
  const ParentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Clean White/Grey Background
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 120),
            child: Column(
              children: [
                _buildChildHeader(),
                const SizedBox(height: 32),
                _buildTimelineList(),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildChildHeader() {
    final child = ParentMockData.lisa;
    // Clean Layout (Dark Text on White)
    return Column(
      children: [
        // Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("Leo's Journal", style: DesignSystem.fontHeader.copyWith(fontSize: 28, color: DesignSystem.textNavy)),
                 Text("Have a great day!", style: DesignSystem.fontBody.copyWith(color: DesignSystem.textGreyBlue)),
               ],
             ),
             Container(
               padding: const EdgeInsets.all(2),
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 border: Border.all(color: Colors.white, width: 2),
                 boxShadow: DesignSystem.glowShadow,
               ),
               child: CircleAvatar(
                 radius: 24,
                 backgroundImage: NetworkImage(child.imageUrl),
               ),
             ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Info Cards (Status & Last Meal)
        Row(
          children: [
            Expanded(
              child: _InfoCard(
                icon: Icons.check_circle_outline_rounded,
                label: "STATUS",
                value: "Checked In",
                color: DesignSystem.parentGreen,
                bgColor: const Color(0xFFE8F5E9), // Light Green
              ),
            ),
            const SizedBox(width: 16),
             Expanded(
              child: _InfoCard(
                icon: Icons.restaurant_rounded,
                label: "LAST MEAL",
                value: "Lunch (All)",
                color: DesignSystem.parentOrange,
                bgColor: const Color(0xFFFFF3E0), // Light Orange
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildTimelineList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: ParentMockData.todayStory.length,
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemBuilder: (context, index) {
        final event = ParentMockData.todayStory[index];
        return _TimelineItem(event: event, isLast: index == ParentMockData.todayStory.length - 1)
            .animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _InfoCard({
    required this.icon, required this.label, required this.value, required this.color, required this.bgColor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: DesignSystem.glowShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: DesignSystem.fontSmall.copyWith(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text(value, style: DesignSystem.fontTitle.copyWith(fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;

  const _TimelineItem({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time & Line
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(event.time, style: DesignSystem.fontSmall.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: event.color, shape: BoxShape.circle, // Solid Color
                    boxShadow: [BoxShadow(color: event.color.withOpacity(0.4), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Icon(event.icon, size: 20, color: Colors.white), // White Icon
                ),
                if (!isLast)
                   Expanded(
                    child: Container(
                      width: 3, // Thicker, softer line
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: const BoxDecoration(
                        gradient: DesignSystem.storyGradient, // Sky -> Mint gradient
                        borderRadius: BorderRadius.all(Radius.circular(4)), // Rounded line ends
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Bubble
          Expanded(
            child: AppCard(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: DesignSystem.fontTitle.copyWith(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(event.description, style: DesignSystem.fontBody),
                  if (event.imageUrl != null) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        event.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 180,
                        errorBuilder: (context, error, stackTrace) {
                           return Container(
                             height: 180, width: double.infinity,
                             color: DesignSystem.parentCoral.withOpacity(0.1),
                             child: const Icon(Icons.broken_image_rounded, color: DesignSystem.parentCoral),
                           );
                        },
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
