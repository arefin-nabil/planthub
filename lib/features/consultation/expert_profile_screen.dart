import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/star_rating.dart';
import '../../data/mock/mock_data.dart';
import '../../app/routes.dart';

class ExpertProfileScreen extends StatelessWidget {
  const ExpertProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expert = (ModalRoute.of(context)?.settings.arguments as MockExpert?) ?? MockData.experts.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.darkGreen,
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
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            leadingWidth: 54,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.forestGreen, AppColors.primaryGreen],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16)],
                          ),
                          child: ClipOval(child: CachedNetworkImage(imageUrl: expert.imageUrl, fit: BoxFit.cover)),
                        ),
                        if (expert.available)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(expert.name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(expert.title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StarRating(rating: expert.rating, showCount: false, starSize: 16),
                        const SizedBox(width: 6),
                        Text('${expert.rating} · ${expert.consultations} পরামর্শ',
                            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Specialty & Price
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            border: Border.all(color: AppColors.lightBorder),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.spa_rounded, color: AppColors.primaryGreen, size: 24),
                              const SizedBox(height: 6),
                              Text('বিশেষত্ব', style: AppTextStyles.bodySmall(context)),
                              Text(expert.specialty, style: AppTextStyles.h3(context).copyWith(fontSize: 13), textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkCard : Colors.white,
                            borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                            border: Border.all(color: AppColors.lightBorder),
                          ),
                          child: Column(
                            children: [
                              const Icon(Icons.payments_outlined, color: AppColors.primaryGreen, size: 24),
                              const SizedBox(height: 6),
                              Text('প্রতি সেশন', style: AppTextStyles.bodySmall(context)),
                              Text('৳${expert.pricePerSession}', style: AppTextStyles.price(context)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Skills
                  Text('দক্ষতা', style: AppTextStyles.sectionTitle(context)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: expert.skills.map((s) => Chip(label: Text(s))).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Consultation types
                  Text('পরামর্শের ধরন', style: AppTextStyles.sectionTitle(context)),
                  const SizedBox(height: 10),
                  ...AppConstants.consultationTypes.map((type) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(color: AppColors.lightBorder),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          type == 'চ্যাট' ? Icons.chat_bubble_outline_rounded : Icons.image_outlined,
                          color: AppColors.primaryGreen,
                          size: 22,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(type, style: AppTextStyles.h3(context).copyWith(fontSize: 14)),
                              Text(
                                type == 'চ্যাট' ? 'সরাসরি মেসেজ করুন' : 'ছবি পাঠিয়ে মতামত নিন',
                                style: AppTextStyles.bodySmall(context),
                              ),
                            ],
                          ),
                        ),
                        Text('৳${expert.pricePerSession}', style: AppTextStyles.price(context).copyWith(fontSize: 14)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -4))],
        ),
        child: ElevatedButton(
          onPressed: expert.available
              ? () => Navigator.pushNamed(context, AppRoutes.bookConsultation, arguments: expert)
              : null,
          child: Text(expert.available ? 'পরামর্শ বুক করুন' : 'এক্সপার্ট ব্যস্ত আছেন'),
        ),
      ),
    );
  }
}
