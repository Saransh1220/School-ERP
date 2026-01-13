import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../data/parent_repository.dart';
import '../../../auth/presentation/auth_providers.dart';

class ParentProfileScreen extends ConsumerStatefulWidget {
  const ParentProfileScreen({super.key});

  @override
  ConsumerState<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends ConsumerState<ParentProfileScreen> {
  late Future<StudentProfile> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = ParentRepository.getStudentProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 120),
            child: FutureBuilder<StudentProfile>(
              future: _profileFuture,
              builder: (context, snapshot) {
                 if (!snapshot.hasData) {
                  return const SizedBox(height: 400, child: Center(child: CircularProgressIndicator()));
                }
                final child = snapshot.data!;
                
                return Column(
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: DesignSystem.glowShadow,
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(child.photoUrl),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(child.name, style: DesignSystem.fontHeader.copyWith(fontSize: 24, color: DesignSystem.textNavy)),
                          Text(child.className, style: DesignSystem.fontBody.copyWith(color: DesignSystem.textGreyBlue)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Info Section
                    AppCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _ProfileRow(icon: Icons.school_rounded, label: "Class", value: child.className),
                          const Divider(height: 32),
                          _ProfileRow(icon: Icons.person_rounded, label: "Teacher", value: child.teacherName),
                          const Divider(height: 32),
                          const _ProfileRow(icon: Icons.cake_rounded, label: "Age", value: "4 Years"), // Still hardcoded for now or add to model
                          const Divider(height: 32),
                           _ProfileRow(icon: Icons.tag_rounded, label: "Student ID", value: child.id),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Emergency Contacts (Still Mocked or could comprise list in model)
                    Align(alignment: Alignment.centerLeft, child: Text("Emergency Contacts", style: DesignSystem.fontTitle)),
                    const SizedBox(height: 12),
                    const _ContactTile(name: "Sarah (Mom)", phone: "+1 234 567 890"),
                    const SizedBox(height: 12),
                    const _ContactTile(name: "Mike (Dad)", phone: "+1 987 654 321"),

                    const SizedBox(height: 40),
                    // Logout Helper
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                           ref.read(authControllerProvider.notifier).logout();
                        },
                        icon: const Icon(Icons.logout, color: Colors.red),
                        label: const Text("Sign Out", style: TextStyle(color: Colors.red)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.red.withOpacity(0.5)),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const Positioned(
            top: 0, left: 0, right: 0,
            child: GlassHeader(title: "Profile", subtitle: "Student Info"),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _ProfileRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: DesignSystem.parentTeal.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: DesignSystem.parentTeal, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: DesignSystem.fontSmall),
            Text(value, style: DesignSystem.fontBody.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}

class _ContactTile extends StatelessWidget {
  final String name;
  final String phone;
  const _ContactTile({required this.name, required this.phone});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
               Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.phone_rounded, color: Colors.green, size: 20),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: DesignSystem.fontBody.copyWith(fontWeight: FontWeight.bold)),
                  Text(phone, style: DesignSystem.fontSmall),
                ],
              ),
            ],
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
