import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/plant_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/nursery_badge.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../core/widgets/role_switcher_bar.dart';
import '../../../core/widgets/faceted_filter_sheet.dart';
import '../../../core/widgets/growth_timeline_widget.dart';
import '../../../data/mock/mock_data.dart';
import '../../../providers/providers.dart';
import 'explore_page.dart';
import 'wishlist_page.dart';
import '../../cart/pages/cart_page.dart';
import '../../profile/pages/profile_page.dart';
import '../../ai_lens/pages/ai_lens_page.dart';
import '../../care_hub/pages/plant_care_hub_page.dart';
import '../../../app/routes.dart';


class HomePage extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final ThemeMode themeMode;

  const HomePage({super.key, this.onThemeToggle, required this.themeMode});

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final PageController _bannerController = PageController();
  int _bannerIndex = 0;
  int _navIndex = 0;
  String _selectedCategory = 'সব';

  @override
  void initState() {
    super.initState();
    // Auto-scroll banner
    Future.delayed(const Duration(seconds: 3), _autoscroll);
  }

  void _autoscroll() {
    if (!mounted) return;
    final next = (_bannerIndex + 1) % MockData.banners.length;
    _bannerController.animateToPage(
      next,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(seconds: 3), _autoscroll);
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.themeMode == ThemeMode.dark ||
        (widget.themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    return Scaffold(
      body: IndexedStack(
        index: _navIndex,
        children: [
          _buildHomeBody(context, isDark),
          const AiLensScreen(),
          const PlantCareHubScreen(),
          const CartScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildHomeBody(BuildContext context, bool isDark) {
    return CustomScrollView(
      slivers: [
        // Sliver AppBar with Bangla Greeting & Language Toggle (বাং | EN)
        SliverAppBar(
          expandedHeight: 0,
          floating: true,
          snap: true,
          backgroundColor: isDark ? AppColors.darkBg : AppColors.softWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Center(
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.2),
                    width: 0.8,
                  ),
                ),
                child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 20),
              ),
            ),
          ),
          leadingWidth: 54,
          title: Consumer<LocaleProvider>(
            builder: (context, localeProv, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localeProv.isBangla ? 'শুভ সকাল 🌿' : 'Good Morning 🌿',
                    style: AppTextStyles.h2(context).copyWith(
                      color: AppColors.primaryGreen,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    localeProv.isBangla ? 'সবুজায়নে স্বাগতম · প্রাকৃতিক গাছ' : 'Welcome to Sobujayon',
                    style: AppTextStyles.bodySmall(context).copyWith(
                      fontSize: 10,
                      color: isDark ? AppColors.textDarkSecondary : AppColors.naturalGray,
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            // Language Toggle Button (বাং | EN)
            Consumer<LocaleProvider>(
              builder: (context, localeProv, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: InkWell(
                    onTap: () => localeProv.toggleLanguage(),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.primaryGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'বাং',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: localeProv.isBangla ? FontWeight.w800 : FontWeight.w500,
                              color: localeProv.isBangla ? AppColors.primaryGreen : AppColors.naturalGray,
                            ),
                          ),
                          const Text(' | ', style: TextStyle(fontSize: 10, color: AppColors.naturalGray)),
                          Text(
                            'EN',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: localeProv.isEnglish ? FontWeight.w800 : FontWeight.w500,
                              color: localeProv.isEnglish ? AppColors.primaryGreen : AppColors.naturalGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 4),
            Builder(
              builder: (context) {
                final cartCount = context.select<CartProvider, int>((c) => c.totalItemCount);
                return AppBarActionButton(
                  icon: Icons.shopping_bag_outlined,
                  badgeCount: cartCount,
                  tooltip: 'শপিং ব্যাগ',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                );
              },
            ),
            AppBarActionButton(
              icon: isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              tooltip: 'থিম পরিবর্তন',
              onTap: () {
                if (widget.onThemeToggle != null) {
                  widget.onThemeToggle!();
                } else {
                  context.read<ThemeProvider>().toggleTheme();
                }
              },
            ),
            const SizedBox(width: 8),
          ],
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ultra-clean 30px pill search bar with Centered AI Camera lens
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : Colors.white,
                    borderRadius: BorderRadius.circular(30), // 30px rounded corners
                    border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AppColors.naturalGray, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, AppRoutes.explore),
                          child: Text(
                            'গাছ বা নার্সারি খুঁজুন...',
                            style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.naturalGray, fontSize: 13),
                          ),
                        ),
                      ),
                      // AI Lens trigger pill (Direct switch to AI Lens tab)
                      GestureDetector(
                        onTap: () => setState(() => _navIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.sobujayonSecondary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.center_focus_strong_rounded, color: AppColors.sobujayonSecondary, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'AI লেন্স',
                                style: TextStyle(
                                  color: AppColors.sobujayonSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      // Filter icon
                      Builder(
                        builder: (ctx) {
                          final filterCount = ctx.select<MarketplaceProvider, int>((m) => m.activeFilterCount);
                          return GestureDetector(
                            onTap: () => FacetedFilterSheet.show(context),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: filterCount > 0 ? AppColors.primaryGreen : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                color: filterCount > 0 ? Colors.white : AppColors.naturalGray,
                                size: 18,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // Followed Nurseries Story Row (Live ring effect)
                _buildFollowedNurseriesStories(context, isDark),
                const SizedBox(height: 18),

                // Banner Carousel
                _buildBanner(context),
                const SizedBox(height: 24),

                // Category chips
                SectionHeader(title: 'ক্যাটাগরি', onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildCategories(context),
                const SizedBox(height: 24),

                // Featured plants
                SectionHeader(
                  title: 'ফিচার্ড প্ল্যান্টস',
                  subtitle: 'এই সপ্তাহের বিশেষ বাছাই',
                  onSeeAll: () => Navigator.pushNamed(context, AppRoutes.explore),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        // Plants horizontal list
        SliverToBoxAdapter(
          child: SizedBox(
            height: AppConstants.productCardHeight,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: MockData.plants.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => PlantCard(
                plant: MockData.plants[index],
                onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: MockData.plants[index]),
              ),
            ),
          ),
        ),

        // 2-Column Product Grid (Design Spec: Product Cards in 2-column grid)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
            child: SectionHeader(
              title: 'জনপ্রিয় কালেকশন',
              subtitle: 'সেরা নার্সারি থেকে সরাসরি সেরা দামে বাছাইকৃত গাছ',
              onSeeAll: () => Navigator.pushNamed(context, AppRoutes.explore),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.60,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final plant = MockData.plants[index % MockData.plants.length];
                return PlantCard(
                  plant: plant,
                  width: double.infinity,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: plant),
                );
              },
              childCount: 4,
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Nurseries
                SectionHeader(title: 'শীর্ষ নার্সারি', onSeeAll: () {}),
                const SizedBox(height: 12),
                _buildNurseries(context),
                const SizedBox(height: 24),

                // Real Customer Growth Timeline
                const GrowthTimelineWidget(plantName: 'মানি প্ল্যান্ট ও ইনডোর কালেকশন'),
                const SizedBox(height: 24),

                // Stitch Editorial Care Spotlight Banner
                _buildStitchCareSpotlight(context),
                const SizedBox(height: 24),

                // Campaign banner
                _buildCampaignBanner(context),
                const SizedBox(height: 24),

                // Knowledge Hub preview
                SectionHeader(
                  title: 'নলেজ হাব',
                  subtitle: 'গাছের যত্নে সেরা টিপস',
                  onSeeAll: () => Navigator.pushNamed(context, AppRoutes.knowledgeHub),
                ),
                const SizedBox(height: 12),
                _buildArticles(context),
                const SizedBox(height: 24),

                // Expert CTA
                _buildExpertCTA(context),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBanner(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: AppConstants.bannerHeight,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: MockData.banners.length,
            onPageChanged: (i) => setState(() => _bannerIndex = i),
            itemBuilder: (context, index) {
              final banner = MockData.banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryGreen.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: banner['image']!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.lightGreen.withOpacity(0.2)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.centerLeft,
                            colors: [
                              Colors.transparent,
                              AppColors.forestGreen.withOpacity(0.85),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        bottom: 20,
                        right: 100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              banner['title']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              banner['subtitle']!,
                              style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                banner['cta']!,
                                style: const TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        AnimatedSmoothIndicator(
          activeIndex: _bannerIndex,
          count: MockData.banners.length,
          effect: const ExpandingDotsEffect(
            dotColor: AppColors.lightGreen,
            activeDotColor: AppColors.primaryGreen,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: AppConstants.plantCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = AppConstants.plantCategories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat);
              context.read<MarketplaceProvider>().setCategory(cat);
              if (cat != 'সব') {
                setState(() => _navIndex = 1);
              }
            },
            child: AnimatedContainer(
              duration: AppConstants.animFast,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                borderRadius: BorderRadius.circular(AppConstants.radiusCircle),
                border: Border.all(
                  color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.naturalGray,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNurseries(BuildContext context) {
    return SizedBox(
      height: AppConstants.nurseryCardHeight + 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: MockData.nurseries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final nursery = MockData.nurseries[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.nurseryProfile, arguments: nursery),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(color: AppColors.lightBorder, width: 0.8),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                    child: CachedNetworkImage(
                      imageUrl: nursery.imageUrl,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nursery.name,
                          style: AppTextStyles.h3(context).copyWith(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        NurseryBadge(verified: nursery.verified, premium: nursery.premium),
                        const SizedBox(height: 3),
                        Text(
                          nursery.location,
                          style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFA726)),
                            const SizedBox(width: 2),
                            Text(
                              '${nursery.rating} · ${nursery.productCount} গাছ',
                              style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStitchCareSpotlight(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.sobujayonPrimaryContainer, AppColors.sobujayonPrimary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppColors.sobujayonPrimary.withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.eco_rounded, color: AppColors.sobujayonSecondaryContainer, size: 18),
              SizedBox(width: 6),
              Text(
                'সবুজ টিপস',
                style: TextStyle(
                  color: AppColors.sobujayonSecondaryContainer,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'শীতের শেষে মনস্টেরার বিশেষ যত্ন',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'নতুন কুঁড়ি আসার এই মৌসুমে পাতার ধুলা মুছে ফেলুন এবং সঠিক আর্দ্রতা বজায় রাখুন।',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _navIndex = 2), // switch to Care Hub tab
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'গাইডটি পড়ুন',
                    style: TextStyle(
                      color: AppColors.sobujayonPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, color: AppColors.sobujayonPrimary, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFAEEA00), Color(0xFF76FF03)],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFAEEA00).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '⚡ ফ্ল্যাশ সেল',
                    style: TextStyle(color: Colors.black87, fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'কিচেন গার্ডেন প্যাক',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '৫টি ভেষজ গাছ মাত্র ৳৯৯৯-এ',
                  style: TextStyle(color: Colors.black54, fontSize: 13),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.forestGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'এখনই অর্ডার করুন',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.local_florist_rounded, size: 72, color: Colors.black12),
        ],
      ),
    );
  }

  Widget _buildArticles(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: MockData.articles.take(3).length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final article = MockData.articles[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, AppRoutes.articleDetail, arguments: article),
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(color: AppColors.lightBorder, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLg)),
                    child: CachedNetworkImage(
                      imageUrl: article.imageUrl,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            article.category,
                            style: AppTextStyles.badge(context).copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: 9,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          article.titleBn,
                          style: AppTextStyles.h3(context).copyWith(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 10, color: AppColors.naturalGray),
                            const SizedBox(width: 3),
                            Text(article.readTime, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExpertCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkGreen, AppColors.primaryGreen],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'গাছে সমস্যা?',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 6),
                Text(
                  'আমাদের বিশেষজ্ঞরা সাহায্য করতে প্রস্তুত। চ্যাট বা ছবি দেখিয়ে পরামর্শ নিন।',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13, height: 1.5),
                ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.expertList),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'এক্সপার্ট খুঁজুন',
                      style: TextStyle(color: AppColors.primaryGreen, fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.support_agent_rounded, size: 64, color: Colors.white24),
        ],
      ),
    );
  }

  Widget _buildFollowedNurseriesStories(BuildContext context, bool isDark) {
    final nurseries = MockData.nurseries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'অনুসরণ করা নার্সারি',
                  style: AppTextStyles.h3(context).copyWith(fontSize: 14),
                ),
              ],
            ),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.explore),
              child: Text(
                'সব দেখুন',
                style: AppTextStyles.bodySmall(context).copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: nurseries.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final n = nurseries[index];
              final hasNewStock = index % 2 == 0;
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.nurseryProfile, arguments: n),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Gradient "Live" Ring
                        Container(
                          width: 60,
                          height: 60,
                          padding: const EdgeInsets.all(2.5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: hasNewStock
                                ? const LinearGradient(
                                    colors: [AppColors.primaryGreen, AppColors.terracotta, AppColors.lightGreen],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            border: hasNewStock
                                ? null
                                : Border.all(
                                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                                    width: 1.5,
                                  ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? AppColors.darkCard : Colors.white,
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: n.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // "LIVE" Badge
                        if (hasNewStock)
                          Positioned(
                            bottom: -3,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: AppColors.terracotta,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: isDark ? AppColors.darkCard : Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 7),
                    SizedBox(
                      width: 66,
                      child: Text(
                        n.name,
                        style: AppTextStyles.bodySmall(context).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = context.select<CartProvider, int>((c) => c.totalItemCount);

    final items = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.yard_outlined),
        activeIcon: Icon(Icons.yard_rounded),
        label: 'হোম',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.center_focus_strong_outlined),
        activeIcon: Icon(Icons.center_focus_strong_rounded),
        label: 'লেন্স',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.water_drop_outlined),
        activeIcon: Icon(Icons.water_drop_rounded),
        label: 'যত্ন',
      ),
      BottomNavigationBarItem(
        icon: Badge(
          isLabelVisible: cartCount > 0,
          label: Text('$cartCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
          backgroundColor: AppColors.sobujayonSecondary,
          child: const Icon(Icons.shopping_bag_outlined),
        ),
        activeIcon: Badge(
          isLabelVisible: cartCount > 0,
          label: Text('$cartCount', style: const TextStyle(fontSize: 10, color: Colors.white)),
          backgroundColor: AppColors.sobujayonSecondary,
          child: const Icon(Icons.shopping_bag_rounded),
        ),
        label: 'ব্যাগ',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline_rounded),
        activeIcon: Icon(Icons.person_rounded),
        label: 'প্রোফাইল',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppColors.darkSurface : AppColors.sobujayonSurfaceContainerLowest).withValues(alpha: 0.92),
        border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : const Color(0xFFE8EFEA), width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF012D1D).withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        selectedItemColor: AppColors.sobujayonPrimary,
        unselectedItemColor: isDark ? AppColors.textDarkSecondary : const Color(0xFF607268),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        elevation: 0,
        items: items,
      ),
    );
  }
}


/// Compatibility typedef
typedef HomeScreen = HomePage;
