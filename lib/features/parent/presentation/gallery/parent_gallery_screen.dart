import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../data/parent_repository.dart';

class ParentGalleryScreen extends StatefulWidget {
  const ParentGalleryScreen({super.key});

  @override
  State<ParentGalleryScreen> createState() => _ParentGalleryScreenState();
}

class _ParentGalleryScreenState extends State<ParentGalleryScreen> {
  late Future<List<GalleryPhoto>> _galleryFuture;

  @override
  void initState() {
    super.initState();
    _galleryFuture = ParentRepository.getGalleryPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      body: Stack(
        children: [
          // Content
          FutureBuilder<List<GalleryPhoto>>(
            future: _galleryFuture,
            builder: (context, snapshot) {
               if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final photos = snapshot.data!;

              return MasonryGridView.count(
                padding: const EdgeInsets.fromLTRB(16, 120, 16, 100),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return _GalleryCard(photo: photo, index: index)
                      .animate().fadeIn(delay: (100 * index).ms).slideY(begin: 0.2, end: 0);
                },
              );
            },
          ),
          
          // Header
          const Positioned(
            top: 0, left: 0, right: 0,
            child: GlassHeader(title: "Gallery", subtitle: "Memories"),
          ),
        ],
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  final GalleryPhoto photo;
  final int index;

  const _GalleryCard({required this.photo, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: DesignSystem.softShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.network(
              photo.imageUrl,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(photo.caption, style: DesignSystem.fontBody.copyWith(color: Colors.white, fontSize: 14)),
                    Text(photo.date, style: DesignSystem.fontSmall.copyWith(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
