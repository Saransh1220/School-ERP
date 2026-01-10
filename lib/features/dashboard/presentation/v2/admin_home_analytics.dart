import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../../../core/widgets/v2/nav_pill.dart';
import 'package:fl_chart/fl_chart.dart'; // Reusing fl_chart if available, else placeholders

class AdminHomeAnalytics extends StatelessWidget {
  const AdminHomeAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: const Color(0xFFECEFF1),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 120, bottom: 100, left: 24, right: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCards(),
                const SizedBox(height: 32),
                Text("Weekly Activity", style: DesignSystem.fontTitle),
                const SizedBox(height: 16),
                _buildChartCard(),
                 const SizedBox(height: 32),
                 Text("Alerts", style: DesignSystem.fontTitle),
                 const SizedBox(height: 16),
                 _buildAlertList(),
              ],
            ),
          ),
          
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassHeader(
              title: "Dashboard",
              subtitle: "SPRINGFIELD KINDERGARTEN",
              trailing: CircleAvatar(
                backgroundColor: DesignSystem.adminNavy,
                child: Icon(Icons.person, color: Colors.white),
              ),
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
  
  Widget _buildOverviewCards() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      children: [
        _KpiCard(
          label: "Attendance",
          value: "96%",
          trend: "+2%",
          color: DesignSystem.adminTeal,
           icon: Icons.people_rounded,
        ),
        _KpiCard(
          label: "Revenue",
          value: "\$42k",
          trend: "Stable",
          color: DesignSystem.adminNavy,
           icon: Icons.attach_money_rounded,
        ),
         _KpiCard(
          label: "Enrollment",
          value: "142",
          trend: "+5",
          color: DesignSystem.parentBlue,
           icon: Icons.school_rounded,
        ),
         _KpiCard(
          label: "Staff",
          value: "12/12",
          trend: "Full",
          color: DesignSystem.teacherYellow,
           icon: Icons.badge_rounded,
        ),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildChartCard() {
    return AppCard(
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
             gridData: const FlGridData(show: false),
             titlesData: const FlTitlesData(show: false),
             borderData: FlBorderData(show: false),
             lineBarsData: [
               LineChartBarData(
                 spots: const [
                   FlSpot(0, 3),
                   FlSpot(1, 1),
                   FlSpot(2, 4),
                   FlSpot(3, 2),
                   FlSpot(4, 5),
                   FlSpot(5, 3),
                   FlSpot(6, 4),
                 ],
                 isCurved: true,
                 color: DesignSystem.adminTeal,
                 barWidth: 4,
                 isStrokeCapRound: true,
                 belowBarData: BarAreaData(show: true, color: DesignSystem.adminTeal.withOpacity(0.1)),
                 dotData: const FlDotData(show: false),
               ),
             ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
  
  Widget _buildAlertList() {
    return Column(
       children: [
         AppCard(
           padding: const EdgeInsets.all(16),
           child: Row(
             children: [
               const Icon(Icons.warning_amber_rounded, color: Colors.orange),
               const SizedBox(width: 16),
               Expanded(
                 child: Text("Outstanding fees for 3 families", style: DesignSystem.fontBody),
               ),
                const Icon(Icons.chevron_right_rounded, color: DesignSystem.textSecondary),
             ],
           ),
         ),
       ],
    ).animate().fadeIn(delay: 400.ms);
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final Color color;
  final IconData icon;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                 child: Icon(icon, color: color, size: 20),
               ),
               Text(trend, style: DesignSystem.fontSmall.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: DesignSystem.fontHeader.copyWith(fontSize: 24)),
              Text(label, style: DesignSystem.fontSmall),
            ],
          ),
        ],
      ),
    );
  }
}
