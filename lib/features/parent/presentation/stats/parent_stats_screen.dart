import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';

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
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text("Attendance", style: DesignSystem.fontBody.copyWith(fontWeight: FontWeight.bold)),
               Text("98%", style: DesignSystem.fontHeader.copyWith(fontSize: 24, color: DesignSystem.parentBlue)),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: LineChart(
               LineChartData(
                 gridData: const FlGridData(show: false),
                 titlesData: FlTitlesData(
                   leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                   bottomTitles: AxisTitles(
                     sideTitles: SideTitles(
                       showTitles: true,
                       getTitlesWidget: (value, meta) {
                         const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
                         if (value.toInt() < 0 || value.toInt() >= days.length) return const SizedBox();
                         return Padding(
                           padding: const EdgeInsets.only(top: 8.0),
                           child: Text(days[value.toInt()], style: DesignSystem.fontSmall),
                         );
                       },
                     ),
                   ),
                 ),
                 borderData: FlBorderData(show: false),
                 lineBarsData: [
                   LineChartBarData(
                     spots: const [
                       FlSpot(0, 1),
                       FlSpot(1, 1),
                       FlSpot(2, 0.5), // Late
                       FlSpot(3, 1),
                       FlSpot(4, 1),
                     ],
                     isCurved: true,
                     color: DesignSystem.parentSky,
                     barWidth: 6,
                     isStrokeCapRound: true,
                     dotData: const FlDotData(show: false),
                     belowBarData: BarAreaData(show: true, color: DesignSystem.parentSky.withOpacity(0.1)),
                   ),
                 ],
               ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
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
       child: SizedBox(
         height: 200,
         child: PieChart(
           PieChartData(
             sections: [
               PieChartSectionData(color: DesignSystem.parentCoral, value: 40, title: "Art", radius: 50, showTitle: false),
               PieChartSectionData(color: DesignSystem.parentMint, value: 30, title: "Play", radius: 50, showTitle: false),
               PieChartSectionData(color: DesignSystem.parentLavender, value: 30, title: "Music", radius: 50, showTitle: false),
             ],
             centerSpaceRadius: 40,
             sectionsSpace: 4,
           ),
         ),
       ),
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
             decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
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
