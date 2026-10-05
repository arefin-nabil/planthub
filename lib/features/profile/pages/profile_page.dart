import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/cart_provider.dart';
import '../../../providers/wishlist_provider.dart';
import '../../../providers/order_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/locale_provider.dart';
import '../../../app/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ঠিক আছে'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();
    final orderCount = context.watch<OrderProvider>().orders.length;
    final wishlistCount = context.watch<WishlistProvider>().count;
    final cartCount = context.watch<CartProvider>().totalItemCount;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            snap: true,
            backgroundColor: isDark ? AppColors.darkBg : AppColors.softWhite,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              'আমার অ্যাকাউন্ট',
              style: AppTextStyles.h2(context).copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            actions: [
              AppBarActionButton(
                icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                tooltip: 'থিম পরিবর্তন',
                onTap: () => context.read<ThemeProvider>().toggleTheme(),
              ),
              AppBarActionButton(
                icon: Icons.language_rounded,
                tooltip: 'ভাষা (বাং/EN)',
                onTap: () {
                  context.read<LocaleProvider>().toggleLanguage();
                  final isBn = context.read<LocaleProvider>().isBangla;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isBn ? 'ভাষা: বাংলা নির্বাচিত' : 'Language: English selected'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile header card with gradient
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryGreen, AppColors.forestGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 68,
                          height: 68,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(auth.activeRole.icon, color: Colors.white, size: 36),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(auth.user.name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 3),
                              Text(auth.user.email, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${auth.activeRole.titleBn} মোড (${auth.activeRole.titleEn})',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick Stats Row
                  Row(
                    children: [
                      _StatBox(
                        label: 'অর্ডার',
                        value: '$orderCount',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.orderList),
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        label: 'উইশলিস্ট',
                        value: '$wishlistCount',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
                      ),
                      const SizedBox(width: 10),
                      _StatBox(
                        label: 'কার্ট',
                        value: '$cartCount',
                        onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Multi-Role Direct Hub Shortcuts
                  _MenuSection(
                    title: 'রোলের বিশেষ ড্যাশবোর্ড',
                    items: [
                      _MenuItem(
                        Icons.storefront_rounded,
                        'নার্সারি ওনার ড্যাশবোর্ড',
                        () => Navigator.pushNamed(context, AppRoutes.nurseryDashboard),
                      ),
                      _MenuItem(
                        Icons.inventory_2_outlined,
                        'নার্সারি ইনভেন্টরি ও স্টক ম্যানেজার',
                        () => Navigator.pushNamed(context, AppRoutes.nurseryInventory),
                      ),
                      _MenuItem(
                        Icons.bar_chart_rounded,
                        'নার্সারি বিক্রয় অ্যানালিটিক্স',
                        () => Navigator.pushNamed(context, AppRoutes.nurseryAnalytics),
                      ),
                      _MenuItem(
                        Icons.medical_services_outlined,
                        'প্ল্যান্ট ডাক্তার ও পরামর্শ হাব',
                        () => Navigator.pushNamed(context, AppRoutes.expertList),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Customer Orders & Shopping
                  _MenuSection(
                    title: 'কেনাকাটা ও অর্ডার',
                    items: [
                      _MenuItem(Icons.receipt_long_outlined, 'আমার অর্ডার তালিকা', () => Navigator.pushNamed(context, AppRoutes.orderList)),
                      _MenuItem(Icons.favorite_rounded, 'উইশলিস্ট', () => Navigator.pushNamed(context, AppRoutes.wishlist)),
                      _MenuItem(Icons.shopping_cart_outlined, 'আমার কার্ট', () => Navigator.pushNamed(context, AppRoutes.cart)),
                      _MenuItem(
                        Icons.location_on_outlined,
                        'ঠিকানা ব্যবস্থাপনা',
                        () => _showInfoDialog(context, 'ডেলিভারি ঠিকানা', auth.user.address),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Account & Support
                  _MenuSection(
                    title: 'অ্যাকাউন্ট ও নিরাপত্তা',
                    items: [
                      _MenuItem(Icons.notifications_outlined, 'নোটিফিকেশন', () => Navigator.pushNamed(context, AppRoutes.notifications)),
                      _MenuItem(Icons.language_rounded, 'ভাষা: বাংলা (Bilingual UI)', () => _showInfoDialog(context, 'ভাষা নির্বাচন', 'বর্তমান ভাষা: বাংলা। শিগগিরই ইংরেজি চালু হবে।')),
                      _MenuItem(Icons.help_outline_rounded, 'সহায়তা ও লাইভ সাপোর্ট', () => _showInfoDialog(context, 'হেল্প ডেস্ক', 'হটলাইন: ১৬২২২ বা ইমেইল: support@planthub.bd')),
                      _MenuItem(Icons.logout_rounded, 'লগআউট', () => Navigator.pushReplacementNamed(context, AppRoutes.login), isDestructive: true),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // App version
                  Text('PlantHub Bangladesh v1.2.0 • Ultra-Light Edition', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
                  const SizedBox(height: 4),
                  Text('Designed with 💚 for Bangladeshi Plant Lovers', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _StatBox({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Theme.of(context).cardTheme.color,
            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
            border: Border.all(color: AppColors.lightBorder),
          ),
          child: Column(
            children: [
              Text(value, style: AppTextStyles.h1(context).copyWith(color: AppColors.primaryGreen, fontSize: 20)),
              const SizedBox(height: 2),
              Text(label, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;

  const _MenuSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Text(title, style: AppTextStyles.label(context).copyWith(color: AppColors.naturalGray, fontWeight: FontWeight.w700)),
          ),
          ...items.asMap().entries.map((entry) {
            final item = entry.value;
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: (item.isDestructive ? AppColors.error : AppColors.primaryGreen).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(item.icon, size: 18, color: item.isDestructive ? AppColors.error : AppColors.primaryGreen),
                  ),
                  title: Text(
                    item.label,
                    style: AppTextStyles.bodyMedium(context).copyWith(
                      color: item.isDestructive ? AppColors.error : null,
                      fontSize: 13,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: AppColors.naturalGray),
                  onTap: item.onTap,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                ),
                if (!isLast) const Divider(height: 1, indent: 68),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  _MenuItem(this.icon, this.label, this.onTap, {this.isDestructive = false});
}


/// Compatibility typedef
typedef ProfileScreen = ProfilePage;
