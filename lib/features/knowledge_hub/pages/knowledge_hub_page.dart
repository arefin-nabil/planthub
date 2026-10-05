import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../data/mock/mock_data.dart';
import '../../../app/routes.dart';

class KnowledgeHubPage extends StatefulWidget {
  const KnowledgeHubPage({super.key});
  @override
  State<KnowledgeHubPage> createState() => _KnowledgeHubScreenState();
}

class _KnowledgeHubScreenState extends State<KnowledgeHubPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> _tabs = ['সব', 'গাইড', 'রোগ গাইড', 'মৌসুমী টিপস', 'সার গাইড'];

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
    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'নলেজ হাব',
        subtitle: 'গাছের যত্নে সেরা গাইডলাইন ও টিপস',
        showBackButton: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: List.generate(_tabs.length, (tabIndex) {
          final articles = tabIndex == 0
              ? MockData.articles
              : MockData.articles.where((a) => a.category == _tabs[tabIndex]).toList();

          return articles.isEmpty
              ? Center(child: Text('এই বিভাগে কোনো আর্টিকেল নেই', style: AppTextStyles.bodyMedium(context)))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Featured article
                    if (tabIndex == 0) ...[
                      _FeaturedArticle(article: MockData.articles.first),
                      const SizedBox(height: 20),
                      Text('সব আর্টিকেল', style: AppTextStyles.sectionTitle(context)),
                      const SizedBox(height: 12),
                    ],
                    ...articles.skip(tabIndex == 0 ? 1 : 0).map((a) => _ArticleListTile(article: a)),
                  ],
                );
        }),
      ),
    );
  }
}

class _FeaturedArticle extends StatelessWidget {
  final MockArticle article;
  const _FeaturedArticle({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.articleDetail, arguments: article),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(imageUrl: article.imageUrl, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.75)],
                  ),
                ),
              ),
              Positioned(
                left: 16, bottom: 16, right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(article.category, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(height: 6),
                    Text(article.titleBn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16, height: 1.3)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(article.author, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
                        const SizedBox(width: 8),
                        const Icon(Icons.schedule, size: 11, color: Colors.white70),
                        const SizedBox(width: 3),
                        Text(article.readTime, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
                        const Spacer(),
                        Text('${(article.views / 1000).toStringAsFixed(1)}K ভিউ', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArticleListTile extends StatelessWidget {
  final MockArticle article;
  const _ArticleListTile({required this.article});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.articleDetail, arguments: article),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSm),
              child: CachedNetworkImage(imageUrl: article.imageUrl, width: 80, height: 80, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(article.category, style: const TextStyle(color: AppColors.primaryGreen, fontSize: 9, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 6),
                  Text(article.titleBn, style: AppTextStyles.h3(context).copyWith(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(article.author, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
                      const SizedBox(width: 6),
                      const Icon(Icons.schedule, size: 10, color: AppColors.naturalGray),
                      const SizedBox(width: 2),
                      Text(article.readTime, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
                      const Spacer(),
                      const Icon(Icons.visibility_outlined, size: 11, color: AppColors.naturalGray),
                      const SizedBox(width: 3),
                      Text('${(article.views / 1000).toStringAsFixed(1)}K', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/// Compatibility typedef
typedef KnowledgeHubScreen = KnowledgeHubPage;
