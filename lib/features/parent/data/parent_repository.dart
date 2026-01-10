import 'package:flutter/material.dart';
import '../../../../config/design_system.dart';

// --- Data Models ---

class StudentProfile {
  final String id;
  final String name;
  final String photoUrl;
  final String className;
  final String teacherName;
  final String moodEmoji;
  final String status; // "Checked In", "Checked Out"

  const StudentProfile({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.className,
    required this.teacherName,
    required this.moodEmoji,
    required this.status,
  });
}

class DailyActivity {
  final String id;
  final String time;
  final String title;
  final String description;
  final String category; // "Art", "Food", "Sleep", "Play", "CheckIn"
  final String? imageUrl;

  const DailyActivity({
    required this.id,
    required this.time,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
  });

  // Helper to map category to UI properties (could be in UI layer, but handy here for mocks)
  IconData get icon {
    switch (category) {
      case 'Art': return Icons.palette_rounded;
      case 'Food': return Icons.restaurant_rounded;
      case 'Sleep': return Icons.bedtime_rounded;
      case 'Play': return Icons.park_rounded;
      case 'CheckIn': return Icons.check_circle_outline_rounded;
      default: return Icons.star_rounded;
    }
  }

  Color get color {
    switch (category) {
      case 'Art': return DesignSystem.parentOrange; 
      case 'Food': return DesignSystem.parentOrange;
      case 'Sleep': return DesignSystem.parentTeal; 
      case 'Play': return DesignSystem.parentGreen;
      case 'CheckIn': return DesignSystem.parentTeal;
      default: return DesignSystem.textGreyBlue;
    }
  }
}

class AttendanceRecord {
  final DateTime date;
  final String status; // "Present", "Late", "Absent"
  final String checkInTime;
  final String checkOutTime;

  const AttendanceRecord({
    required this.date,
    required this.status,
    required this.checkInTime,
    required this.checkOutTime,
  });
}

class StatsData {
  final Map<String, int> moodCounts; // e.g. {"Happy": 3, "Calm": 2}
  final Map<String, double> activityDistribution; // e.g. {"Gross Motor": 40, "Fine Motor": 35}

  const StatsData({
    required this.moodCounts,
    required this.activityDistribution,
  });
}

class GalleryPhoto {
  final String id;
  final String imageUrl;
  final String date;
  final String caption;

  const GalleryPhoto({
    required this.id,
    required this.imageUrl,
    required this.date,
    required this.caption,
  });
}

// --- Repository (Mock Backend) ---


class ParentRepository {
  
  // Simulate Network Delay
  static Future<void> _delay() async => await Future.delayed(const Duration(milliseconds: 800));

  static Future<StudentProfile> getStudentProfile() async {
    await _delay();
    return const StudentProfile(
      id: "student_123",
      name: "Leo", // Updated name
      photoUrl: "https://ui-avatars.com/api/?name=Leo+D&background=00BFA5&color=fff&size=200", // Teal Background
      className: "Class 3B - Sunflowers",
      teacherName: "Ms. Sarah",
      moodEmoji: "😊",
      status: "Checked In",
    );
  }

  static Future<List<DailyActivity>> getDailyFeed() async {
    await _delay();
    return [
       const DailyActivity(
        id: "1",
        time: "2:30 PM",
        title: "Art & Crafts",
        description: "Leo made a 'Rainbow Cat' with playdough today!",
        category: "Art",
        imageUrl: "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=600&q=80",
      ),
      const DailyActivity(
        id: "2",
        time: "1:00 PM",
        title: "Nap Time",
        description: "Slept for 1h 15m. Woke up happy.",
        category: "Sleep",
      ),
      const DailyActivity(
        id: "3",
        time: "12:00 PM",
        title: "Lunch",
        description: "Ate all the pasta. Left some broccoli.",
        category: "Food",
      ),
      const DailyActivity(
        id: "4",
        time: "10:30 AM",
        title: "Outdoor Play",
        description: "Played on the slide with friends.",
        category: "Play",
      ),
      const DailyActivity(
        id: "5",
        time: "8:45 AM",
        title: "Check In",
        description: "Dropped off by Dad at 8:45 AM.",
        category: "CheckIn",
      ),
    ];
  }

  static Future<List<AttendanceRecord>> getAttendanceHistory() async {
    await _delay();
    final now = DateTime.now();
    return [
      AttendanceRecord(date: now, status: "Present", checkInTime: "9:00 AM", checkOutTime: "3:30 PM"),
      AttendanceRecord(date: now.subtract(const Duration(days: 1)), status: "Present", checkInTime: "9:00 AM", checkOutTime: "3:30 PM"),
      AttendanceRecord(date: now.subtract(const Duration(days: 2)), status: "Late", checkInTime: "9:45 AM", checkOutTime: "3:30 PM"),
      AttendanceRecord(date: now.subtract(const Duration(days: 3)), status: "Present", checkInTime: "9:00 AM", checkOutTime: "3:30 PM"),
      AttendanceRecord(date: now.subtract(const Duration(days: 4)), status: "Absent", checkInTime: "-", checkOutTime: "-"),
    ];
  }

  static Future<StatsData> getChildStats() async {
    await _delay();
    return const StatsData(
      moodCounts: {"Happy": 3, "Calm": 2},
      activityDistribution: {"Gross Motor": 40, "Fine Motor": 35, "Social": 25},
    );
  }

  static Future<List<GalleryPhoto>> getGalleryPhotos() async {
    await _delay();
    return [
      const GalleryPhoto(
        id: "1",
        imageUrl: "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=600&q=80",
        date: "Today",
        caption: "Art Class Masterpiece",
      ),
      const GalleryPhoto(
        id: "2",
        imageUrl: "https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?auto=format&fit=crop&w=600&q=80",
        date: "Yesterday",
        caption: "Outdoor Fun",
      ),
      const GalleryPhoto(
        id: "3",
        imageUrl: "https://images.unsplash.com/photo-1566004100698-33d7b5d13c1a?auto=format&fit=crop&w=600&q=80",
        date: "Oct 24",
        caption: "Reading Time",
      ),
    ];
  }
}

