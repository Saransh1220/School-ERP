import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../data/parent_mock_data.dart';

class ParentGalleryScreen extends StatelessWidget {
  const ParentGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      body: Stack(
        children: [
          MasonryGridView.count(
            padding: const EdgeInsets.fromLTRB(16, 120, 16, 100),
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            itemCount: ParentMockData.gallery.length,
            itemBuilder: (context, index) {
              final photo = ParentMockData.gallery[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(photo.url, fit: BoxFit.cover),
                    Positioned(
                      bottom: 8, left: 8,
                      child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                         child: Text(photo.tag, style: const TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Positioned(
             top: 0, left: 0, right: 0,
            child: GlassHeader(title: "Memories"),
          ),
        ],
      ),
    );
  }
}
