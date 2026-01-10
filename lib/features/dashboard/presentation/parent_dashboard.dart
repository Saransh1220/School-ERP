import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../../core/widgets/activity_tile.dart';
import '../../../../core/widgets/soft_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ParentDashboard extends StatelessWidget {
  const ParentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildChildHeader(context),
          const SizedBox(height: 32),
          Row(
            children: [
              Text(
                'TODAY\'S STORY',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.textGrey,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate().fadeIn().moveX(),
          const SizedBox(height: 16),
          ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              ActivityTile(
                time: '08:30',
                title: 'Morning Check-in',
                description: 'Dropped off by Dad. Happy and energetic!',
                icon: Icons.login_rounded,
                color: ThemeFactory.parentSecondary, // Peach
              ),
              ActivityTile(
                time: '09:00',
                title: 'Breakfast',
                description: 'Ate all pancakes and fruits. Drank water.',
                icon: Icons.restaurant_rounded,
                color: ThemeFactory.teacherSecondary, // Soft Yellow used here for food
              ),
              ActivityTile(
                time: '10:15',
                title: 'Art Class',
                description: 'Painted a beautiful flower garden today.',
                icon: Icons.palette_rounded,
                color: ThemeFactory.parentPrimary, // Sky Blue
              ),
              ActivityTile(
                time: '12:30',
                title: 'Nap Time',
                description: 'Slept for 1h 30m. Woke up refreshed.',
                icon: Icons.bedtime_rounded,
                color: ThemeFactory.parentAccent, // Lavender
                isLast: true,
              ),
            ],
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0),
        ],
      ),
    );
  }

  Widget _buildChildHeader(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Hero(
            tag: 'child_avatar',
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: const DecorationImage(
                  image: NetworkImage('https://ui-avatars.com/api/?name=Lisa+Simpson&background=FFCCB0&color=fff'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: ThemeFactory.parentSecondary.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lisa Simpson',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ThemeFactory.successColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF2E7D32)),
                           SizedBox(width: 6),
                           Text(
                             'Checked In',
                             style: TextStyle(
                               color: Color(0xFF2E7D32),
                               fontWeight: FontWeight.bold,
                               fontSize: 12,
                             ),
                           ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                     Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: ThemeFactory.parentPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        '😊 Happy',
                        style: TextStyle(
                          color: ThemeFactory.parentPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack);
  }
}
