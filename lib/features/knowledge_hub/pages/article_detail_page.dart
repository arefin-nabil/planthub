import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/mock/mock_data.dart';
import '../../../app/routes.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final article = (ModalRoute.of(context)?.settings.arguments as MockArticle?) ?? MockData.articles.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const articleBody = '''
আমাদের এই বিস্তারিত গাইডে আমরা ধাপে ধাপে আলোচনা করব কীভাবে আপনি আপনার বাড়িতে বা অফিসে সুন্দর ইনডোর গাছের পরিবেশ তৈরি করতে পারেন।

**সঠিক গাছ বেছে নিন**

আপনার ঘরের আলো কতটুকু আসে তার উপর নির্ভর করে গাছ বেছে নিন। কম আলোর ঘরে স্নেক প্ল্যান্ট বা পিস লিলি ভালো কাজ করে।

**মাটি ও পট**

ভালো drainage-এর জন্য সর্বদা ছিদ্রযুক্ত পট ব্যবহার করুন। মাটি ভেজা থাকলে শিকড় পচে যেতে পারে।

**পানি দেওয়ার সঠিক নিয়ম**

বেশি পানি দেওয়া গাছের জন্য ক্ষতিকর। আঙুল দিয়ে মাটি পরীক্ষা করুন — শুকনো মনে হলে তখনই পানি দিন।

**সার প্রয়োগ**

বর্ষায় তরল সার ব্যবহার করুন। শীতকালে সার দেওয়া কমিয়ে দিন।
''';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
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
              Padding(
                padding: const EdgeInsets.only(right: 12),
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
                      size: 18,
                      color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(imageUrl: article.imageUrl, fit: BoxFit.cover),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category + time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(article.category, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.schedule, size: 13, color: AppColors.naturalGray),
                      const SizedBox(width: 3),
                      Text(article.readTime, style: AppTextStyles.bodySmall(context)),
                      const Spacer(),
                      const Icon(Icons.visibility_outlined, size: 13, color: AppColors.naturalGray),
                      const SizedBox(width: 3),
                      Text('${(article.views / 1000).toStringAsFixed(1)}K', style: AppTextStyles.bodySmall(context)),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(article.titleBn, style: AppTextStyles.displayMedium(context).copyWith(fontSize: 22)),
                  const SizedBox(height: 8),

                  // Author
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded, color: AppColors.primaryGreen, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.author, style: AppTextStyles.h3(context).copyWith(fontSize: 13)),
                          Text(
                            '${article.date.day}/${article.date.month}/${article.date.year}',
                            style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Article body
                  Text(articleBody, style: AppTextStyles.bodyLarge(context).copyWith(height: 1.9)),
                  const SizedBox(height: 24),

                  // Commission CTA
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(color: AppColors.lightGreen.withOpacity(0.4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.eco_rounded, color: AppColors.primaryGreen),
                            const SizedBox(width: 8),
                            Text('এই আর্টিকেল থেকে কিনুন', style: AppTextStyles.h3(context).copyWith(color: AppColors.primaryGreen)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('এই আর্টিকেলে উল্লিখিত গাছ আমাদের মার্কেটপ্লেস থেকে কিনুন।', style: AppTextStyles.bodyMedium(context)),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.explore),
                          icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                          label: const Text('গাছ দেখুন'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/// Compatibility typedef
typedef ArticleDetailScreen = ArticleDetailPage;
