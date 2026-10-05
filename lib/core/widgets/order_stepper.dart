import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';

/// Horizontal order status stepper
/// Shows: Pending → Confirmed → Packed → Shipped → Delivered
class OrderStepper extends StatelessWidget {
  final String currentStatus;

  const OrderStepper({super.key, required this.currentStatus});

  static const List<_StepInfo> _steps = [
    _StepInfo('Pending', 'পেন্ডিং', Icons.hourglass_empty_rounded),
    _StepInfo('Confirmed', 'কনফার্মড', Icons.check_circle_outline_rounded),
    _StepInfo('Packed', 'প্যাকড', Icons.inventory_2_outlined),
    _StepInfo('Shipped', 'শিপড', Icons.local_shipping_outlined),
    _StepInfo('Delivered', 'ডেলিভারড', Icons.done_all_rounded),
  ];

  int get _currentIndex {
    return _steps.indexWhere(
      (s) => s.status.toLowerCase() == currentStatus.toLowerCase(),
    );
  }

  bool get _isCancelledOrReturned =>
      currentStatus.toLowerCase() == 'cancelled' ||
      currentStatus.toLowerCase() == 'returned';

  @override
  Widget build(BuildContext context) {
    if (_isCancelledOrReturned) {
      return _CancelledBadge(status: currentStatus);
    }

    final current = _currentIndex;

    return Column(
      children: [
        Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Connector line
              final stepIndex = i ~/ 2;
              final isCompleted = stepIndex < current;
              return Expanded(
                child: AnimatedContainer(
                  duration: AppConstants.animMedium,
                  height: 2,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppColors.primaryGreen : AppColors.lightBorder,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              );
            }

            final stepIndex = i ~/ 2;
            final isCompleted = stepIndex < current;
            final isCurrent = stepIndex == current;
            final step = _steps[stepIndex];

            return AnimatedContainer(
              duration: AppConstants.animMedium,
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.primaryGreen
                    : isCurrent
                        ? AppColors.primaryGreen.withOpacity(0.15)
                        : AppColors.lightBorder.withOpacity(0.5),
                shape: BoxShape.circle,
                border: isCurrent
                    ? Border.all(color: AppColors.primaryGreen, width: 2)
                    : null,
              ),
              child: Icon(
                isCompleted ? Icons.check_rounded : step.icon,
                size: 18,
                color: isCompleted
                    ? Colors.white
                    : isCurrent
                        ? AppColors.primaryGreen
                        : AppColors.naturalGray,
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _steps.map((step) {
            final idx = _steps.indexOf(step);
            final isActive = idx <= current;
            return SizedBox(
              width: 60,
              child: Text(
                step.labelBn,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall(context).copyWith(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.primaryGreen : AppColors.naturalGray,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CancelledBadge extends StatelessWidget {
  final String status;
  const _CancelledBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isCancelled = status.toLowerCase() == 'cancelled';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: (isCancelled ? AppColors.error : AppColors.statusReturned).withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(
          color: isCancelled ? AppColors.error : AppColors.statusReturned,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isCancelled ? Icons.cancel_outlined : Icons.assignment_return_outlined,
            color: isCancelled ? AppColors.error : AppColors.statusReturned,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            isCancelled ? 'অর্ডার বাতিল হয়েছে' : 'অর্ডার ফেরত দেওয়া হয়েছে',
            style: AppTextStyles.h3(context).copyWith(
              color: isCancelled ? AppColors.error : AppColors.statusReturned,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepInfo {
  final String status;
  final String labelBn;
  final IconData icon;
  const _StepInfo(this.status, this.labelBn, this.icon);
}
