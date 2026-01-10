import 'package:flutter/material.dart';
import '../../../config/design_system.dart';

// --- Entities ---
class Child {
  final String name;
  final String imageUrl;
  final String className;
  final String teacherName;
  final String moodEmoji;
  final String status; // "Checked In", "Checked Out"

  const Child({
    required this.name,
    required this.imageUrl,
    required this.className,
    required this.teacherName,
    required this.moodEmoji,
    required this.status,
  });
}

class TimelineEvent {
  final String time;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? imageUrl;

  const TimelineEvent({
    required this.time,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.imageUrl,
  });
}

class GalleryPhoto {
  final String url;
  final String tag;
  final String date;

  const GalleryPhoto({required this.url, required this.tag, required this.date});
}

// --- Mock Data Store ---
class ParentMockData {
  static const Child lisa = Child(
    name: "Lisa",
    imageUrl: "https://ui-avatars.com/api/?name=Lisa+S&background=FFCCB0&color=fff&size=200",
    className: "Class 3B - Sunflowers",
    teacherName: "Ms. Sarah",
    moodEmoji: "😊",
    status: "Checked In",
  );

  static const List<TimelineEvent> todayStory = [
     TimelineEvent(
      time: "2:30 PM",
      title: "Art & Crafts",
      description: "Lisa made a 'Rainbow Cat' with playdough today!",
      icon: Icons.palette_rounded,
      color: DesignSystem.parentCoral, // Art -> Coral/Peach
      imageUrl: "https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=600&q=80", // Fixed URL
    ),
    TimelineEvent(
      time: "1:00 PM",
      title: "Nap Time",
      description: "Slept for 1h 15m. Woke up happy.",
      icon: Icons.bedtime_rounded,
      color: DesignSystem.parentLavender, // Sleep -> Lavender
    ),
    TimelineEvent(
      time: "12:00 PM",
      title: "Lunch",
      description: "Ate all the pasta. Left some broccoli.",
      icon: Icons.restaurant_rounded,
      color: DesignSystem.parentYellow, // Food -> Yellow
    ),
    TimelineEvent(
      time: "10:30 AM",
      title: "Outdoor Play",
      description: "Played on the slide with friends.",
      icon: Icons.park_rounded,
      color: DesignSystem.parentMint, // Play -> Mint
    ),
    TimelineEvent(
      time: "8:45 AM",
      title: "Check In",
      description: "Dropped off by Dad at 8:45 AM.",
      icon: Icons.check_circle_outline_rounded,
      color: DesignSystem.parentSky, // Check In -> Sky
    ),
  ];

  static const List<GalleryPhoto> gallery = [
    GalleryPhoto(url: "https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?auto=format&fit=crop&w=600&q=80", tag: "Play", date: "Today"),
    GalleryPhoto(url: "https://images.unsplash.com/photo-1596464716127-f9a804e0647e?auto=format&fit=crop&w=600&q=80", tag: "Art", date: "Today"),
    GalleryPhoto(url: "https://images.unsplash.com/photo-1472162072942-cd5147eb3902?auto=format&fit=crop&w=600&q=80", tag: "Event", date: "Yesterday"),
    GalleryPhoto(url: "https://images.unsplash.com/photo-1595152452543-e5fc28ebab23?auto=format&fit=crop&w=600&q=80", tag: "Art", date: "Mon"),
  ];
  
  // Chart Data (Mock Objects usually) - kept simple for MVP logic
  static const Map<String, double> moodDistribution = {
    "Happy": 45,
    "Calm": 30,
    "Tired": 15,
    "Sad": 10,
  };
}
