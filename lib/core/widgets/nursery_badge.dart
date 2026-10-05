import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Verification badge for nurseries and experts
class NurseryBadge extends StatelessWidget {
  final bool verified;
  final bool premium;

  const NurseryBadge({
    super.key,
    required this.verified,
    this.premium = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!verified) return const SizedBox.shrink();

    if (premium) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
          ),
          borderRadius: BorderRadius.circular(AppConstants.radiusCircle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium, size: 12, color: Colors.white),
            const SizedBox(width: 3),
            Text(
              'Premium Verified',
              style: AppTextStyles.badge(context),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppConstants.radiusCircle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.verified_rounded, size: 12, color: AppColors.primaryGreen),
          const SizedBox(width: 3),
          Text(
            'Verified',
            style: AppTextStyles.badge(context).copyWith(color: AppColors.primaryGreen),
          ),
        ],
      ),
    );
  }
}
