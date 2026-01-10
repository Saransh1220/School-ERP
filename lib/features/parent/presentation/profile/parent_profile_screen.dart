import 'package:flutter/material.dart';
import '../../../../config/design_system.dart';
import '../../../../core/widgets/v2/app_card.dart';
import '../../../../core/widgets/v2/glass_header.dart';
import '../../data/parent_mock_data.dart';

class ParentProfileScreen extends StatelessWidget {
  const ParentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final child = ParentMockData.lisa;
     return Scaffold(
      backgroundColor: DesignSystem.creamWhite,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 120, 24, 120),
            child: Column(
              children: [
                 Center(
                   child: Container(
                     padding: const EdgeInsets.all(4),
                     decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2)]),
                     child: CircleAvatar(radius: 60, backgroundImage: NetworkImage(child.imageUrl)),
                   ),
                 ),
                 const SizedBox(height: 16),
                 Text(child.name, style: DesignSystem.fontHeader),
                 Text("Class 3B - Sunflowers", style: DesignSystem.fontBody.copyWith(color: DesignSystem.textSecondary)),
                 
                 const SizedBox(height: 32),
                 _buildSectionHeader("Personal Info"),
                 _buildInfoCard(
                   items: [
                     _InfoRow(label: "Date of Birth", value: "24 April 2020"),
                     _InfoRow(label: "Blood Group", value: "O+"),
                     _InfoRow(label: "Allergies", value: "Peanuts (Mild)"),
                   ]
                 ),

                 const SizedBox(height: 24),
                 _buildSectionHeader("Emergency Contacts"),
                 _ContactTile(name: "John Doe (Dad)", phone: "+1 234 567 890"),
                 _ContactTile(name: "Sarah Doe (Mom)", phone: "+1 987 654 321"),
              ],
            ),
          ),
          const Positioned(
            top: 0, left: 0, right: 0,
             child: GlassHeader(title: "My Child", trailing: Icon(Icons.settings, color: DesignSystem.textMain)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: DesignSystem.fontTitle.copyWith(fontSize: 18)),
      ),
    );
  }
  
  Widget _buildInfoCard({required List<Widget> items}) {
    return AppCard(
      padding: const EdgeInsets.all(0),
      color: Colors.white,
      child: Column(
        children: items.map((item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: item,
        )).toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: DesignSystem.fontBody.copyWith(color: DesignSystem.textSecondary)),
        Text(value, style: DesignSystem.fontBody.copyWith(fontWeight: FontWeight.w600)),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: AppCard(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: DesignSystem.parentMint.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.phone_rounded, color: Colors.green),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: DesignSystem.fontBody.copyWith(fontWeight: FontWeight.bold)),
                Text(phone, style: DesignSystem.fontSmall),
              ],
            ),
            const Spacer(),
            const Icon(Icons.message_rounded, color: DesignSystem.parentBlue),
          ],
        ),
      ),
    );
  }
}
