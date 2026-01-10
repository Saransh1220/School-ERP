import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../data/parent_repository.dart';

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends State<ParentHomeScreen> {
  late Future<StudentProfile> _profileFuture;
  late Future<List<DailyActivity>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ParentRepository.getStudentProfile();
    _feedFuture = ParentRepository.getDailyFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.iceWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 120),
            child: Column(
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 32),
                _buildTimelineSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return FutureBuilder<StudentProfile>(
      future: _profileFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(height: 100, child: Center(child: CircularProgressIndicator()));
        }
        final child = snapshot.data!;
        
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
                     backgroundImage: NetworkImage(child.photoUrl),
                   ),
                 ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Info Cards (Status & Last Meal) - Mocking "Last Meal" logic for now using static data or we could add to API
            Row(
              children: [
                Expanded(
                  child: _InfoCard(
                    icon: Icons.check_circle_outline_rounded,
                    label: "STATUS",
                    value: child.status,
                    color: DesignSystem.parentGreen,
                    bgColor: const Color(0xFFE8F5E9), // Light Green
                  ),
                ),
                const SizedBox(width: 16),
                 Expanded(
                  child: _InfoCard(
                    icon: Icons.restaurant_rounded,
                    label: "LAST MEAL",
                    value: "Lunch (All)", // Static for now as per design
                    color: DesignSystem.parentOrange,
                    bgColor: const Color(0xFFFFF3E0), // Light Orange
                  ),
                ),
              ],
            ),
          ],
        ).animate().fadeIn().slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildTimelineSection() {
    return FutureBuilder<List<DailyActivity>>(
      future: _feedFuture,
      builder: (context, snapshot) {
         if (!snapshot.hasData) {
          return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
        }
        final events = snapshot.data!;

        return ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 24),
          itemBuilder: (context, index) {
            final event = events[index];
            return _TimelineItem(event: event, index: index).animate().fadeIn(delay: (100 * index).ms).slideX();
          },
        );
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
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: DesignSystem.glowShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: DesignSystem.fontSmall.copyWith(fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: DesignSystem.fontTitle.copyWith(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final DailyActivity event;
  final int index;

  const _TimelineItem({required this.event, required this.index});

  @override
  Widget build(BuildContext context) {
     return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time Column
        SizedBox(
          width: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              event.time,
              style: DesignSystem.fontSmall.copyWith(fontWeight: FontWeight.bold, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        
        // Timeline Line
        Column(
          children: [
            Container(
              width: 2,
              height: 20,
              color: index == 0 ? Colors.transparent : DesignSystem.textGreyBlue.withValues(alpha: 0.2),
            ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: event.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: event.color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ]
              ),
            ),
            Container(
              width: 2,
              height: 100, // Dynamic based on content
              color: DesignSystem.textGreyBlue.withValues(alpha: 0.2),
            ),
          ],
        ),
        const SizedBox(width: 16),

        // Event Card
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 24), // Spacing for line
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: DesignSystem.glowShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Header (if exists)
                if (event.imageUrl != null)
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      event.imageUrl!,
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: event.color.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(event.icon, color: event.color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.title, style: DesignSystem.fontTitle.copyWith(fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(event.description, style: DesignSystem.fontBody.copyWith(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
