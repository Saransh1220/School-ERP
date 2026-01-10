import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../data/parent_repository.dart';

class AttendanceHistoryCard extends StatefulWidget {
  const AttendanceHistoryCard({super.key});

  @override
  State<AttendanceHistoryCard> createState() => _AttendanceHistoryCardState();
}

class _AttendanceHistoryCardState extends State<AttendanceHistoryCard> {
  String _selectedFilter = 'Week'; // Week, Month, Custom
  DateTimeRange? _selectedDateRange;
  late Future<List<AttendanceRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = ParentRepository.getAttendanceHistory();
  }

  Future<void> _selectDateRange() async {
    final DateTime now = DateTime.now();
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: DesignSystem.parentTeal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: DesignSystem.textNavy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  String _getRangeLabel() {
    if (_selectedDateRange == null) return "Select Range";
    final start = "${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}";
    final end = "${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}";
    return "$start - $end";
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Attendance", style: DesignSystem.fontTitle),
              // Filter Chips
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _FilterTab(label: "Week", isSelected: _selectedFilter == 'Week', onTap: () => setState(() => _selectedFilter = 'Week')),
                    _FilterTab(label: "Month", isSelected: _selectedFilter == 'Month', onTap: () => setState(() => _selectedFilter = 'Month')),
                    _FilterTab(label: "Custom", isSelected: _selectedFilter == 'Custom', onTap: () => setState(() => _selectedFilter = 'Custom')),
                  ],
                ),
              ),
            ],
          ),
          
          if (_selectedFilter == 'Custom') 
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: _selectDateRange,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.edit_calendar_rounded, size: 14, color: DesignSystem.parentTeal),
                        const SizedBox(width: 4),
                        Text(
                          _getRangeLabel(), 
                          style: DesignSystem.fontSmall.copyWith(
                            color: DesignSystem.parentTeal, 
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          const SizedBox(height: 24),

          // List Content
          FutureBuilder<List<AttendanceRecord>>(
            future: _historyFuture,
            builder: (context, snapshot) {
               if (!snapshot.hasData) {
                return const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()));
              }
              final records = snapshot.data!;

              return ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: records.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _AttendanceRow(record: records[index]).animate().fadeIn(delay: (50 * index).ms).slideX();
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? DesignSystem.glowShadow : const <BoxShadow>[],
        ),
        child: Text(
          label,
          style: DesignSystem.fontSmall.copyWith(
            color: isSelected ? DesignSystem.parentTeal : DesignSystem.textGreyBlue,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final AttendanceRecord record;
  const _AttendanceRow({required this.record});

  @override
  Widget build(BuildContext context) {
    final status = record.status;
    final color = status == "Present" ? DesignSystem.parentGreen 
        : (status == "Late" ? DesignSystem.parentOrange : Colors.redAccent);
    final icon = status == "Present" ? Icons.check_circle_rounded
        : (status == "Late" ? Icons.access_time_filled_rounded : Icons.cancel_rounded);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: DesignSystem.iceWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Oct ${record.date.day}", style: DesignSystem.fontBody.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(status, style: DesignSystem.fontSmall.copyWith(fontSize: 12, color: color)),
                ],
              ),
            ],
          ),
          Text("${record.checkInTime} - ${record.checkOutTime}", style: DesignSystem.fontSmall.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}
