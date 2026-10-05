import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PlantVitalityBadge extends StatelessWidget {
  final String sunlight;
  final String water;
  final String? careLevel;
  final bool compact;

  const PlantVitalityBadge({
    super.key,
    required this.sunlight,
    required this.water,
    this.careLevel,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: [
        _buildChip(
          context,
          icon: Icons.wb_sunny_rounded,
          iconColor: const Color(0xFFFFA000),
          bgColor: const Color(0xFFFFF8E1),
          text: sunlight,
        ),
        _buildChip(
          context,
          icon: Icons.water_drop_rounded,
          iconColor: const Color(0xFF0288D1),
          bgColor: const Color(0xFFE1F5FE),
          text: water,
        ),
        if (careLevel != null)
          _buildChip(
            context,
            icon: Icons.spa_rounded,
            iconColor: AppColors.primaryGreen,
            bgColor: const Color(0xFFE8F5E9),
            text: careLevel!,
          ),
      ],
    );
  }

  Widget _buildChip(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: isDark ? iconColor.withOpacity(0.15) : bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? iconColor.withOpacity(0.3) : iconColor.withOpacity(0.2),
          width: 0.6,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 11 : 13, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
