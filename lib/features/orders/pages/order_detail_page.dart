import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/order_stepper.dart';
import '../../../data/mock/mock_data.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../provider/order_provider.dart';


class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeOrder = (ModalRoute.of(context)?.settings.arguments as MockOrder?) ?? MockData.orders.first;
    final orderProvider = context.watch<OrderProvider>();
    final currentOrder = orderProvider.orders.firstWhere((o) => o.id == routeOrder.id, orElse: () => routeOrder);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'অর্ডারের বিবরণ',
        subtitle: currentOrder.id,
        showBackButton: true,
        actions: [
          AppBarActionButton(
            icon: Icons.download_outlined,
            tooltip: 'ইনভয়েস ডাউনলোড',
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('ইনভয়েস PDF'),
                  content: Text('অর্ডার ${currentOrder.id}-এর ইনভয়েস সফলভাবে জেনারেট হয়েছে।'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('ঠিক আছে'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status stepper
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('অর্ডার স্ট্যাটাস', style: AppTextStyles.h3(context)),
                  const SizedBox(height: 16),
                  OrderStepper(currentStatus: currentOrder.status),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Product info
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(color: AppColors.lightBorder),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(imageUrl: currentOrder.plantImage, width: 70, height: 70, fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(currentOrder.plantName, style: AppTextStyles.h3(context)),
                        const SizedBox(height: 4),
                        Text('নার্সারি: ${currentOrder.nurseryName}', style: AppTextStyles.bodySmall(context)),
                        const SizedBox(height: 4),
                        Text('পরিমাণ: ${currentOrder.quantity}টি', style: AppTextStyles.bodySmall(context)),
                        const SizedBox(height: 4),
                        Text('৳${currentOrder.total.toInt()}', style: AppTextStyles.price(context).copyWith(fontSize: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Delivery info
            _InfoCard(
              title: 'ডেলিভারি ঠিকানা',
              icon: Icons.location_on_outlined,
              children: [
                _InfoRow('নাম', 'রাহেলা বেগম'),
                _InfoRow('ঠিকানা', 'বাড়ি ৫, রোড ৮, ধানমন্ডি, ঢাকা ১২০৫'),
                _InfoRow('মোবাইল', '+880 1712-345678'),
              ],
            ),
            const SizedBox(height: 12),

            // Payment info
            _InfoCard(
              title: 'পেমেন্ট তথ্য',
              icon: Icons.payment_rounded,
              children: [
                _InfoRow('পদ্ধতি', 'ক্যাশ অন ডেলিভারি'),
                _InfoRow('অর্ডার তারিখ', '${currentOrder.date.day}/${currentOrder.date.month}/${currentOrder.date.year}'),
                _InfoRow('মোট মূল্য', '৳${currentOrder.total.toInt()}'),
                _InfoRow('ডেলিভারি চার্জ', '৳৮০'),
                _InfoRow('পরিশোধযোগ্য', '৳${currentOrder.total.toInt()}', isBold: true),
              ],
            ),
            const SizedBox(height: 16),

            // Action buttons
            if (currentOrder.status.toLowerCase() == 'pending')
              OutlinedButton.icon(
                onPressed: () {
                  context.read<OrderProvider>().cancelOrder(currentOrder.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('অর্ডার বাতিল করা হয়েছে')),
                  );
                },
                icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
                label: const Text('অর্ডার বাতিল করুন', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.error)),
              ),
            if (currentOrder.status.toLowerCase() == 'delivered')
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ধন্যবাদ! আপনার রিভিউ জমা হয়েছে।')),
                  );
                },
                icon: const Icon(Icons.star_outline_rounded),
                label: const Text('রিভিউ দিন'),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  const _InfoCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 6),
              Text(title, style: AppTextStyles.h3(context).copyWith(color: AppColors.primaryGreen, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _InfoRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 12)),
          ),
          Expanded(
            child: Text(
              value,
              style: isBold
                  ? AppTextStyles.h3(context).copyWith(fontSize: 14, color: AppColors.primaryGreen)
                  : AppTextStyles.bodyMedium(context).copyWith(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}


/// Compatibility typedef
typedef OrderDetailScreen = OrderDetailPage;
