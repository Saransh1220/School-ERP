import 'package:flutter/material.dart';
import '../../../../config/theme.dart';
import '../../../../core/widgets/role/admin_stat_card.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'School Overview',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // KPI Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.3,
            children: const [
              AdminStatCard(
                title: 'Attendance',
                value: '94%',
                trend: '+2.4%',
                isTrendUp: true,
                icon: Icons.people_outline,
                color: ThemeFactory.adminPrimary,
              ),
              AdminStatCard(
                title: 'Revenue',
                value: '\$12.5k',
                trend: '+12%',
                isTrendUp: true,
                icon: Icons.attach_money,
                color: ThemeFactory.adminSecondary,
              ),
              AdminStatCard(
                title: 'Staffing',
                value: '14/15',
                trend: '-1',
                isTrendUp: false,
                icon: Icons.work_outline,
                color: Colors.orange,
              ),
              AdminStatCard(
                title: 'Incidents',
                value: '0',
                trend: 'Stable',
                isTrendUp: true,
                icon: Icons.health_and_safety,
                color: Colors.redAccent,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            'Weekly Attendance Trends',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Chart
          Card(
             elevation: 0,
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade200)),
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: SizedBox(
                 height: 200,
                 child: BarChart(
                   BarChartData(
                     gridData: const FlGridData(show: false),
                     titlesData: FlTitlesData(
                       leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                       topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                       rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                       bottomTitles: AxisTitles(
                         sideTitles: SideTitles(
                           showTitles: true,
                           getTitlesWidget: (value, meta) {
                              const days = ['M', 'T', 'W', 'T', 'F'];
                              if (value.toInt() < days.length) {
                                return Text(days[value.toInt()], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12));
                              }
                              return const Text('');
                           },
                         ),
                       ),
                     ),
                     borderData: FlBorderData(show: false),
                     barGroups: [
                       _makeGroupData(0, 18),
                       _makeGroupData(1, 19),
                       _makeGroupData(2, 20),
                       _makeGroupData(3, 17),
                       _makeGroupData(4, 19),
                     ],
                   ),
                 ),
               ),
             ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: ThemeFactory.adminPrimary,
          width: 16,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
        ),
      ],
    );
  }
}
