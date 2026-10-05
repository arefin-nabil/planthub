import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/star_rating.dart';
import '../../../core/widgets/nursery_badge.dart';
import '../../../core/widgets/growth_timeline_widget.dart';
import '../../../data/mock/mock_data.dart';
import '../../../providers/providers.dart';
import '../../../app/routes.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key});

  @override
  State<ProductDetailPage> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailPage> with SingleTickerProviderStateMixin {
  int _qty = 1;
  int _selectedImageIndex = 0;
  bool _isFollowing = false;
  late TabController _tabController;

  final List<String> _tabs = ['বিবরণ', 'যত্ন', 'রিভিউ', 'গ্রোথ টাইমলাইন'];
  String _selectedSize = 'মাঝারি';

  double _currentPrice(MockPlant plant) {
    if (_selectedSize == 'ছোট') return plant.price * 0.8;
    if (_selectedSize == 'বড়') return plant.price * 1.3;
    return plant.price;
  }

  Widget _buildSizeOption(String label, String dimension, double factor) {
    final isSelected = _selectedSize == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSize = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.sobujayonPrimary : AppColors.sobujayonSurfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.sobujayonPrimary : AppColors.lightBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppColors.sobujayonPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                dimension,
                style: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF607268),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plant = (ModalRoute.of(context)?.settings.arguments as MockPlant?) ?? MockData.plants.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Use same image multiple times for demo gallery
    final images = List.generate(4, (_) => plant.imageUrl);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softWhite,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Image gallery
              SliverAppBar(
                expandedHeight: MediaQuery.of(context).size.height * 0.45,
                pinned: true,
                backgroundColor: isDark ? AppColors.darkBg : AppColors.softWhite,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Center(
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard.withValues(alpha: 0.85)
                              : Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                leadingWidth: 54,
                actions: [
                  Builder(
                    builder: (context) {
                      final isWish = context.watch<WishlistProvider>().isWishlisted(plant.id);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        child: InkWell(
                          onTap: () => context.read<WishlistProvider>().toggleWishlist(plant),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkCard.withValues(alpha: 0.85)
                                  : Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                width: 0.8,
                              ),
                            ),
                            child: Icon(
                              isWish ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isWish ? AppColors.error : AppColors.naturalGray,
                              size: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 12, top: 8, bottom: 8),
                    child: InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('লিঙ্ক কপি করা হয়েছে')),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard.withValues(alpha: 0.85)
                              : Colors.white.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            width: 0.8,
                          ),
                        ),
                        child: Icon(
                          Icons.share_outlined,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.naturalGray,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: images[_selectedImageIndex],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.lightGreen.withOpacity(0.2)),
                      ),
                      if (plant.originalPrice != null)
                        Positioned(
                          bottom: 60,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '-${((1 - plant.price / plant.originalPrice!) * 100).round()}% ছাড়',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ),
                        ),
                      // Thumbnail strip
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Row(
                          children: List.generate(images.length, (i) => GestureDetector(
                            onTap: () => setState(() => _selectedImageIndex = i),
                            child: AnimatedContainer(
                              duration: AppConstants.animFast,
                              margin: const EdgeInsets.only(left: 6),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: _selectedImageIndex == i ? AppColors.primaryGreen : Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: CachedNetworkImage(imageUrl: images[i], fit: BoxFit.cover),
                              ),
                            ),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header block: Title, Species & Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.4),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    plant.name.toUpperCase(),
                                    style: const TextStyle(
                                      color: AppColors.sobujayonSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  plant.nameBn,
                                  style: AppTextStyles.h1(context).copyWith(
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '৳${_currentPrice(plant).toInt()}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.sobujayonOnTertiaryContainer,
                                ),
                              ),
                              const Text(
                                'ভ্যাট অন্তর্ভুক্ত',
                                style: TextStyle(fontSize: 10, color: Color(0xFF607268)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating + Sold
                      Row(
                        children: [
                          StarRating(rating: plant.rating, count: plant.reviewCount),
                          const SizedBox(width: 12),
                          Container(
                            width: 1,
                            height: 16,
                            color: AppColors.lightBorder,
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.shopping_bag_outlined, size: 14, color: AppColors.naturalGray),
                          const SizedBox(width: 4),
                          Text('${plant.sold} বিক্রি', style: AppTextStyles.bodySmall(context)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Care Dashboard (3 Glassmorphic Tiles: Water, Sun, Temp)
                      Row(
                        children: [
                          Expanded(
                            child: _GlassCareTile(
                              emoji: '💧',
                              value: plant.water.isNotEmpty ? plant.water : '২ দিন পরপর',
                              title: 'পানি দিন',
                              accentColor: const Color(0xFF0284C7),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _GlassCareTile(
                              emoji: '☀️',
                              value: plant.sunlight.isNotEmpty ? plant.sunlight : 'আংশিক ছায়া',
                              title: 'সূর্যালোক',
                              accentColor: const Color(0xFFD97706),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _GlassCareTile(
                              emoji: '🌡️',
                              value: '২৫°-৩০° সে.',
                              title: 'তাপমাত্রা',
                              accentColor: AppColors.terracotta,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Stitch Size & Vessel Selector
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'গাছের আকার ও টব',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.sobujayonPrimary,
                                ),
                              ),
                              Text(
                                'হাতে গড়া মাটির টব সহ',
                                style: TextStyle(fontSize: 11, color: Color(0xFF607268)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildSizeOption('ছোট', '১২ ইঞ্চি', 0.8),
                              const SizedBox(width: 8),
                              _buildSizeOption('মাঝারি', '২৪ ইঞ্চি', 1.0),
                              const SizedBox(width: 8),
                              _buildSizeOption('বড়', '৩৬ ইঞ্চি', 1.3),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Key Attribute Highlights (2 cards in grid)
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.air_rounded, size: 20, color: AppColors.sobujayonSecondary),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('বায়ু শোধক', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.sobujayonPrimary)),
                                        Text('প্রাকৃতিক এয়ার ফিল্টার', style: TextStyle(fontSize: 9.5, color: Color(0xFF607268))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLow,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.palette_outlined, size: 20, color: AppColors.sobujayonOnTertiaryContainer),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('মাটির টব', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.sobujayonPrimary)),
                                        Text('টেরাকোটা আর্ট কালেকশন', style: TextStyle(fontSize: 9.5, color: Color(0xFF607268))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Stitch Botanical Soil & Packaging Quality Guarantee
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.sobujayonSecondary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 18),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'সবুজায়ন সেফটি গ্যারান্টি: ৭ দিনের সুস্থ উদ্ভিদের নিশ্চয়তা',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.sobujayonPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Nursery Section with Follow Button
                      _buildNurseryBar(context, plant),
                      const SizedBox(height: 18),

                      // Tabs
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : Colors.white,
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                        ),
                        child: Column(
                          children: [
                            TabBar(
                              controller: _tabController,
                              isScrollable: true,
                              tabs: _tabs.map((t) => Tab(text: t)).toList(),
                            ),
                            SizedBox(
                              height: 280,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  _DescriptionTab(plant: plant),
                                  _CareTab(plant: plant),
                                  _ReviewsTab(plant: plant),
                                  _GrowthTab(plantName: plant.nameBn),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4)),
                ],
              ),
              child: Row(
                children: [
                  // Quantity control
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.lightBorder),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_rounded, size: 18),
                          onPressed: () { if (_qty > 1) setState(() => _qty--); },
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        ),
                        SizedBox(
                          width: 28,
                          child: Text('$_qty', textAlign: TextAlign.center, style: AppTextStyles.h3(context)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, size: 18),
                          onPressed: () => setState(() => _qty++),
                          padding: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                          color: AppColors.primaryGreen,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.sobujayonPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                      ),
                      onPressed: () {
                        context.read<CartProvider>().addItem(plant, quantity: _qty);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${plant.nameBn} ($_qtyটি) ব্যাগে যোগ করা হয়েছে!'),
                            action: SnackBarAction(
                              label: 'ব্যাগ দেখুন',
                              textColor: Colors.white,
                              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                            ),
                            backgroundColor: AppColors.sobujayonPrimary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'ব্যাগে যোগ করুন  •  ৳${(_currentPrice(plant) * _qty).toInt()}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNurseryBar(BuildContext context, MockPlant plant) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nursery = MockData.nurseries.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.nurseryProfile, arguments: nursery),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(imageUrl: nursery.imageUrl, width: 42, height: 42, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.nurseryProfile, arguments: nursery),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          plant.nurseryName,
                          style: AppTextStyles.h3(context).copyWith(fontSize: 13),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      NurseryBadge(verified: plant.nurseryVerified, premium: plant.nurseryPremium),
                    ],
                  ),
                  Text(nursery.location, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Follow button ("অনুসরণ করুন" / "অনুসরণ করছেন")
          InkWell(
            onTap: () {
              setState(() => _isFollowing = !_isFollowing);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isFollowing ? '${plant.nurseryName} অনুসরণ করা শুরু হয়েছে!' : 'অনুসরণ বাতিল করা হয়েছে'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isFollowing
                    ? AppColors.primaryGreen.withOpacity(0.12)
                    : AppColors.primaryGreen,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primaryGreen,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isFollowing ? Icons.check_rounded : Icons.add_rounded,
                    size: 13,
                    color: _isFollowing ? AppColors.primaryGreen : Colors.white,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isFollowing ? 'অনুসরণ করছেন' : 'অনুসরণ করুন',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _isFollowing ? AppColors.primaryGreen : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCareTile extends StatelessWidget {
  final String emoji;
  final String value;
  final String title;
  final Color accentColor;

  const _GlassCareTile({
    required this.emoji,
    required this.value,
    required this.title,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard.withOpacity(0.8) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: accentColor.withOpacity(0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 7),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextStyles.h3(context).copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: AppTextStyles.bodySmall(context).copyWith(
              fontSize: 10,
              color: AppColors.naturalGray,
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionTab extends StatelessWidget {
  final MockPlant plant;
  const _DescriptionTab({required this.plant});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '${plant.nameBn} (${plant.name}) একটি চমৎকার ইনডোর গাছ যা আপনার ঘরের পরিবেশকে সুন্দর ও সতেজ করে তোলে। এটি বাড়ির যেকোনো কোণে রাখা যায় এবং বায়ু পরিশোধনেও সাহায্য করে।\n\nআমাদের নার্সারিতে এই গাছটি জৈব মাটিতে চাষ করা হয় এবং কোনো ক্ষতিকর রাসায়নিক ব্যবহার করা হয় না।',
        style: AppTextStyles.bodyMedium(context),
      ),
    );
  }
}

class _CareTab extends StatelessWidget {
  final MockPlant plant;
  const _CareTab({required this.plant});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CareRow(icon: Icons.wb_sunny_outlined, label: 'আলো', value: plant.sunlight),
          _CareRow(icon: Icons.water_drop_outlined, label: 'পানি', value: plant.water),
          _CareRow(icon: Icons.thermostat, label: 'তাপমাত্রা', value: '১৮-২৮°C'),
          _CareRow(icon: Icons.spa_rounded, label: 'যত্ন', value: plant.careLevel),
        ],
      ),
    );
  }
}

class _CareRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _CareRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.primaryGreen),
          const SizedBox(width: 10),
          Text('$label:', style: AppTextStyles.label(context)),
          const SizedBox(width: 6),
          Text(value, style: AppTextStyles.bodyMedium(context).copyWith(fontSize: 13)),
        ],
      ),
    );
  }
}

class _ReviewsTab extends StatelessWidget {
  final MockPlant plant;
  const _ReviewsTab({required this.plant});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text('${plant.rating}', style: AppTextStyles.priceLarge(context).copyWith(fontSize: 42)),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StarRating(rating: plant.rating, showCount: false),
                  const SizedBox(height: 4),
                  Text('${plant.reviewCount} রিভিউ', style: AppTextStyles.bodySmall(context)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GrowthTab extends StatelessWidget {
  final String plantName;
  const _GrowthTab({required this.plantName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GrowthTimelineWidget(plantName: plantName),
    );
  }
}


/// Compatibility typedef
typedef ProductDetailScreen = ProductDetailPage;
