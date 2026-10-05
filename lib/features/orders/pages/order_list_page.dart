import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../provider/order_provider.dart';

import '../../../app/routes.dart';

class OrderListPage extends StatelessWidget {
  const OrderListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'আমার অর্ডারসমূহ',
        subtitle: orders.isNotEmpty ? '${orders.length}টি অর্ডার নথিভুক্ত' : null,
        showBackButton: Navigator.canPop(context),
      ),
      body: orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.primaryGreen),
                  ),
                  const SizedBox(height: 16),
                  Text('কোনো অর্ডার পাওয়া যায়নি', style: AppTextStyles.h2(context)),
                  const SizedBox(height: 8),
                  Text('আপনি এখনো কোনো গাছ অর্ডার করেননি', style: AppTextStyles.bodyMedium(context)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.explore),
                    child: const Text('গাছ কালেকশন দেখুন'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail, arguments: order),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardTheme.color,
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                      border: Border.all(color: AppColors.lightBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(order.id, style: AppTextStyles.label(context).copyWith(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
                            const Spacer(),
                            _StatusChip(status: order.status),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: order.plantImage,
                                width: 56,
                                height: 56,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(order.plantName, style: AppTextStyles.h3(context).copyWith(fontSize: 14)),
                                  const SizedBox(height: 3),
                                  Text(order.nurseryName, style: AppTextStyles.bodySmall(context)),
                                  const SizedBox(height: 3),
                                  Text('পরিমাণ: ${order.quantity}টি গাছ', style: AppTextStyles.bodySmall(context)),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('৳${order.total.toInt()}', style: AppTextStyles.price(context).copyWith(fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(
                                  '${order.date.day}/${order.date.month}/${order.date.year}',
                                  style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined, size: 14, color: AppColors.primaryGreen),
                            const SizedBox(width: 4),
                            Text('ট্র্যাকিং ও লাইভ বিবরণ দেখুন', style: AppTextStyles.label(context).copyWith(color: AppColors.primaryGreen, fontSize: 12)),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.naturalGray),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  Color get _color {
    switch (status.toLowerCase()) {
      case 'pending': return AppColors.statusPending;
      case 'confirmed': return AppColors.statusConfirmed;
      case 'packed': return AppColors.statusPacked;
      case 'shipped': return AppColors.statusShipped;
      case 'delivered': return AppColors.statusDelivered;
      case 'cancelled': return AppColors.statusCancelled;
      default: return AppColors.statusReturned;
    }
  }

  String get _labelBn {
    switch (status.toLowerCase()) {
      case 'pending': return 'অপেক্ষমান (Pending)';
      case 'confirmed': return 'গৃহীত (Confirmed)';
      case 'packed': return 'প্যাকেজিং (Packed)';
      case 'shipped': return 'পথে আছে (Shipped)';
      case 'delivered': return 'পৌঁছে গেছে (Delivered)';
      case 'cancelled': return 'বাতিল (Cancelled)';
      default: return 'রিটার্ন';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.4)),
      ),
      child: Text(
        _labelBn,
        style: TextStyle(color: _color, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}


/// Compatibility typedef
typedef OrderListScreen = OrderListPage;
