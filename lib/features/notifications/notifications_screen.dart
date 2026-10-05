import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/app_top_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<_Notification> _notifications = [
    _Notification(
      type: 'order',
      title: 'অর্ডার শিপ হয়েছে',
      body: 'আপনার Monstera Deliciosa অর্ডার (ORD-2026-001) শিপ করা হয়েছে।',
      time: '২ ঘণ্টা আগে',
      isRead: false,
    ),
    _Notification(
      type: 'consultation',
      title: 'পরামর্শ কনফার্ম',
      body: 'ড. সাদিয়া ইসলামের সাথে আপনার পরামর্শ কনফার্ম হয়েছে।',
      time: '৫ ঘণ্টা আগে',
      isRead: false,
    ),
    _Notification(
      type: 'promo',
      title: 'বিশেষ অফার!',
      body: 'ইনডোর গাছে ২০% ছাড়। আজই অর্ডার করুন!',
      time: '১ দিন আগে',
      isRead: true,
    ),
    _Notification(
      type: 'review',
      title: 'রিভিউ দিন',
      body: 'Peace Lily পাওয়ার ৩০ দিন হয়ে গেছে। গ্রোথ ছবি যোগ করুন!',
      time: '২ দিন আগে',
      isRead: true,
    ),
    _Notification(
      type: 'stock',
      title: 'উইশলিস্টে স্টক এসেছে',
      body: 'Fiddle Leaf Fig আবার স্টকে এসেছে!',
      time: '৩ দিন আগে',
      isRead: true,
    ),
    _Notification(
      type: 'system',
      title: 'আপনার অ্যাকাউন্ট ভেরিফাই হয়েছে',
      body: 'আপনার নার্সারি Verified ব্যাজ পেয়েছে।',
      time: '৫ দিন আগে',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unread = _notifications.where((n) => !n.isRead).toList();
    final read = _notifications.where((n) => n.isRead).toList();

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'নোটিফিকেশন',
        subtitle: unread.isNotEmpty ? '${unread.length}টি নতুন বার্তা' : null,
        showBackButton: true,
        actions: [
          if (unread.isNotEmpty)
            AppBarActionButton(
              icon: Icons.done_all_rounded,
              tooltip: 'সব পড়া হয়েছে',
              onTap: () => setState(() {
                for (var n in _notifications) {
                  n.isRead = true;
                }
              }),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (unread.isNotEmpty) ...[
            _GroupHeader(title: 'অপঠিত (${unread.length})', color: AppColors.primaryGreen),
            const SizedBox(height: 8),
            ...unread.map((n) => _NotificationTile(notification: n, onTap: () => setState(() => n.isRead = true))),
            const SizedBox(height: 16),
          ],
          if (read.isNotEmpty) ...[
            _GroupHeader(title: 'পঠিত', color: AppColors.naturalGray),
            const SizedBox(height: 8),
            ...read.map((n) => _NotificationTile(notification: n, onTap: () {})),
          ],
        ],
      ),
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String title;
  final Color color;
  const _GroupHeader({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.sectionTitle(context).copyWith(color: color, fontSize: 14));
  }
}

class _NotificationTile extends StatelessWidget {
  final _Notification notification;
  final VoidCallback onTap;
  const _NotificationTile({required this.notification, required this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case 'order': return Icons.local_shipping_outlined;
      case 'consultation': return Icons.medical_services_outlined;
      case 'promo': return Icons.local_offer_outlined;
      case 'review': return Icons.star_outline_rounded;
      case 'stock': return Icons.inventory_2_outlined;
      default: return Icons.info_outline_rounded;
    }
  }

  Color get _color {
    switch (notification.type) {
      case 'order': return AppColors.statusShipped;
      case 'consultation': return AppColors.info;
      case 'promo': return AppColors.warning;
      case 'review': return Color(0xFFFFA726);
      case 'stock': return AppColors.success;
      default: return AppColors.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppConstants.animFast,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? AppColors.darkCard : Colors.white)
              : _color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(
            color: notification.isRead ? AppColors.lightBorder : _color.withOpacity(0.3),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: _color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: AppTextStyles.h3(context).copyWith(
                            fontSize: 14,
                            fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!notification.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(notification.body, style: AppTextStyles.bodySmall(context), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(notification.time, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Notification {
  final String type;
  final String title;
  final String body;
  final String time;
  bool isRead;
  _Notification({required this.type, required this.title, required this.body, required this.time, required this.isRead});
}
