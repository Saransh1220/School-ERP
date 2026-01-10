import 'package:flutter/material.dart';
import '../../../config/design_system.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        gradient: color == null ? DesignSystem.cardGradient : null,
        borderRadius: DesignSystem.radiusL,
        boxShadow: DesignSystem.softLift,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: DesignSystem.radiusL,
          splashColor: DesignSystem.parentBlue.withOpacity(0.1),
          highlightColor: DesignSystem.parentBlue.withOpacity(0.05),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
