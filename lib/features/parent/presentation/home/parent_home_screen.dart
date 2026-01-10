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
      backgroundColor: DesignSystem.creamWhite, // Warm background
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
          const Positioned(
            top: 0, left: 0, right: 0,
            child: GlassHeader(title: "Today's Story", subtitle: "THUR, OCT 25"),
          ),
        ],
      ),
    );
  }

  Widget _buildChildHeader() {
    final child = ParentMockData.lisa;
    // Use Emotional Gradient (Coral -> Cream) for the header card
    return Container(
      decoration: BoxDecoration(
        gradient: DesignSystem.parentGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: DesignSystem.glowShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(24), // Increased padding
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: CircleAvatar(
                radius: 36,
                backgroundImage: NetworkImage(child.imageUrl),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(child.name, style: DesignSystem.fontHeader.copyWith(fontSize: 24)),
                  Text(child.className, style: DesignSystem.fontSmall),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _StatusChip(label: child.status, color: DesignSystem.parentSky),
                      const SizedBox(width: 8),
                      _StatusChip(label: "Feeling ${child.moodEmoji}", color: DesignSystem.parentYellow),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: DesignSystem.fontSmall.copyWith(color: DesignSystem.textNavy, fontSize: 12, fontWeight: FontWeight.bold),
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
                  decoration: BoxDecoration(color: event.color.withOpacity(0.2), shape: BoxShape.circle),
                  child: Icon(event.icon, size: 20, color: event.color),
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
