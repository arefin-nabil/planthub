import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/plant_card.dart';
import '../../core/widgets/nursery_badge.dart';
import '../../core/widgets/star_rating.dart';
import '../../data/mock/mock_data.dart';
import '../../app/routes.dart';

class NurseryProfileScreen extends StatefulWidget {
  const NurseryProfileScreen({super.key});
  @override
  State<NurseryProfileScreen> createState() => _NurseryProfileScreenState();
}

class _NurseryProfileScreenState extends State<NurseryProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nursery = (ModalRoute.of(context)?.settings.arguments as MockNursery?) ?? MockData.nurseries.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 220,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(imageUrl: nursery.coverUrl, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: isDark ? AppColors.darkBg : AppColors.softWhite,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primaryGreen, width: 3),
                          boxShadow: [BoxShadow(color: AppColors.primaryGreen.withOpacity(0.2), blurRadius: 12)],
                        ),
                        child: ClipOval(child: CachedNetworkImage(imageUrl: nursery.imageUrl, fit: BoxFit.cover)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(nursery.name, style: AppTextStyles.h2(context)),
                            const SizedBox(height: 4),
                            NurseryBadge(verified: nursery.verified, premium: nursery.premium),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 13, color: AppColors.naturalGray),
                                const SizedBox(width: 3),
                                Text(nursery.location, style: AppTextStyles.bodySmall(context)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Stats row
                  Row(
                    children: [
                      _StatItem(label: 'গাছ', value: '${nursery.productCount}+'),
                      Container(width: 1, height: 32, color: AppColors.lightBorder, margin: const EdgeInsets.symmetric(horizontal: 16)),
                      _StatItem(label: 'রিভিউ', value: '${nursery.reviewCount}'),
                      Container(width: 1, height: 32, color: AppColors.lightBorder, margin: const EdgeInsets.symmetric(horizontal: 16)),
                      Column(
                        children: [
                          StarRating(rating: nursery.rating, showCount: false, starSize: 14),
                          const SizedBox(height: 2),
                          Text('রেটিং', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(nursery.description, style: AppTextStyles.bodyMedium(context).copyWith(height: 1.6)),
                  const SizedBox(height: 14),
                  // Follow button
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _isFollowing = !_isFollowing),
                          child: AnimatedContainer(
                            duration: AppConstants.animFast,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _isFollowing ? AppColors.primaryGreen.withOpacity(0.1) : AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.primaryGreen),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isFollowing ? Icons.check_rounded : Icons.add_rounded,
                                  size: 18,
                                  color: _isFollowing ? AppColors.primaryGreen : Colors.white,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isFollowing ? 'ফলো করছেন' : 'ফলো করুন',
                                  style: TextStyle(
                                    color: _isFollowing ? AppColors.primaryGreen : Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.phone_outlined, color: AppColors.primaryGreen),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.lightBorder),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.share_outlined, color: AppColors.naturalGray),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'প্রোডাক্টস'),
                      Tab(text: 'গ্যালারি'),
                      Tab(text: 'রিভিউ'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            // Products tab
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: MockData.plants.length,
              itemBuilder: (context, index) => PlantCard(
                plant: MockData.plants[index],
                width: double.infinity,
                onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: MockData.plants[index]),
              ),
            ),
            // Gallery
            GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: MockData.plants.length,
              itemBuilder: (context, index) => ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(imageUrl: MockData.plants[index].imageUrl, fit: BoxFit.cover),
              ),
            ),
            // Reviews
            const Center(child: Text('রিভিউ সেকশন')),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  const _StatItem({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.h2(context).copyWith(color: AppColors.primaryGreen)),
        const SizedBox(height: 2),
        Text(label, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
      ],
    );
  }
}
