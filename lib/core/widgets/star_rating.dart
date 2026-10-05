import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Star rating display widget
class StarRating extends StatelessWidget {
  final double rating;
  final int count;
  final double starSize;
  final bool showCount;

  const StarRating({
    super.key,
    required this.rating,
    this.count = 0,
    this.starSize = 16,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (index) {
          if (index < rating.floor()) {
            return Icon(Icons.star_rounded, color: const Color(0xFFFFA726), size: starSize);
          } else if (index < rating.ceil() && rating % 1 != 0) {
            return Icon(Icons.star_half_rounded, color: const Color(0xFFFFA726), size: starSize);
          } else {
            return Icon(Icons.star_border_rounded, color: AppColors.naturalGray.withOpacity(0.4), size: starSize);
          }
        }),
        if (showCount && count > 0) ...[
          const SizedBox(width: 4),
          Text(
            '($count)',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ],
    );
  }
}
