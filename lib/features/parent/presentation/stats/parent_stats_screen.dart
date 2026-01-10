import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../../common/presentation/widgets/attendance_card.dart';

class ParentStatsScreen extends StatelessWidget {
  const ParentStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Weekly Insights", style: DesignSystem.fontTitle),
                const SizedBox(height: 16),
                _buildAttendanceChart(),
                const SizedBox(height: 24),
                
                Text("Mood Trends", style: DesignSystem.fontTitle),
                 const SizedBox(height: 16),
                _buildMoodGrid(),
                 const SizedBox(height: 24),

                Text("Activity Mix", style: DesignSystem.fontTitle),
                 const SizedBox(height: 16),
                _buildActivityPie(),
              ],
            ),
          ),
           const Positioned(
            top: 0, left: 0, right: 0,
            child: GlassHeader(title: "Dashboard", subtitle: "Last 7 Days"),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceChart() {
    return const AttendanceHistoryCard();
    // return const AppCard(child: Center(child: Text("Attendance Module Placeholder")));
  }

  Widget _buildMoodGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3, // Taller tiles to prevent overflow
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _StatTile(label: "Happy", value: "3 Days", color: DesignSystem.parentYellow, icon: "😊"),
        _StatTile(label: "Calm", value: "2 Days", color: DesignSystem.parentSky, icon: "😌"),
      ],
    );
  }
  
  Widget _buildActivityPie() {
     return AppCard(
       padding: const EdgeInsets.all(24),
       child: Column(
         children: [
           SizedBox(
             height: 200,
             child: PieChart(
               PieChartData(
                 sections: [
                   PieChartSectionData(color: DesignSystem.parentOrange, value: 35, title: "", radius: 45),
                   PieChartSectionData(color: DesignSystem.parentGreen, value: 40, title: "", radius: 55), // Highlight
                   PieChartSectionData(color: DesignSystem.parentTeal, value: 25, title: "", radius: 45),
                 ],
                 centerSpaceRadius: 50,
                 sectionsSpace: 4,
               ),
             ),
           ),
           const SizedBox(height: 24),
           // Detailed Metrics Legend
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: [
               _ChartLegend(color: DesignSystem.parentGreen, label: "Gross Motor", value: "40%"),
               _ChartLegend(color: DesignSystem.parentOrange, label: "Fine Motor", value: "35%"),
               _ChartLegend(color: DesignSystem.parentTeal, label: "Social", value: "25%"),
             ],
           ),
         ],
       ),
     );
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  final String value;
  
  const _ChartLegend({required this.color, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Text(label, style: DesignSystem.fontSmall.copyWith(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: DesignSystem.fontTitle.copyWith(fontSize: 16)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final String icon;

  const _StatTile({required this.label, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
             child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 8),
          Text(value, style: DesignSystem.fontTitle),
          Text(label, style: DesignSystem.fontSmall),
        ],
      ),
    );
  }
}
