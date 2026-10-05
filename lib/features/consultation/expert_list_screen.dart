import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/widgets/star_rating.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../data/mock/mock_data.dart';
import '../../app/routes.dart';

class ExpertListScreen extends StatefulWidget {
  const ExpertListScreen({super.key});
  @override
  State<ExpertListScreen> createState() => _ExpertListScreenState();
}

class _ExpertListScreenState extends State<ExpertListScreen> {
  String _selectedSpecialty = 'সব';
  final List<String> _specialties = ['সব', 'রোগ নির্ণয়', 'ইনডোর কেয়ার', 'ল্যান্ডস্কেপ', 'জৈব চাষ'];

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedSpecialty == 'সব'
        ? MockData.experts
        : MockData.experts.where((e) => e.specialty.contains(_selectedSpecialty)).toList();

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'গাছের ডাক্তার ও বিশেষজ্ঞ',
        subtitle: '${filtered.length} জন বিশেষজ্ঞ উপলব্ধ',
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Header CTA
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.darkGreen, AppColors.primaryGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
            ),
            child: Row(
              children: [
                const Icon(Icons.support_agent_rounded, color: Colors.white, size: 40),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('গাছের সমস্যা?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                      Text('বিশেষজ্ঞের পরামর্শ নিন', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 14),
              ],
            ),
          ),

          // Specialty filter
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _specialties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final s = _specialties[index];
                final isSelected = _selectedSpecialty == s;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSpecialty = s),
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.naturalGray,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Expert list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _ExpertCard(expert: filtered[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpertCard extends StatelessWidget {
  final MockExpert expert;
  const _ExpertCard({required this.expert});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.expertProfile, arguments: expert),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(AppConstants.radiusLg),
          border: Border.all(color: AppColors.lightBorder),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + available badge
            Stack(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: expert.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                if (expert.available)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(expert.name, style: AppTextStyles.h3(context)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: expert.available
                              ? AppColors.success.withOpacity(0.1)
                              : AppColors.naturalGray.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          expert.available ? 'উপলব্ধ' : 'ব্যস্ত',
                          style: TextStyle(
                            color: expert.available ? AppColors.success : AppColors.naturalGray,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(expert.title, style: AppTextStyles.bodySmall(context)),
                  const SizedBox(height: 6),
                  // Skills
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: expert.skills.take(2).map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(s, style: TextStyle(color: AppColors.primaryGreen, fontSize: 10, fontWeight: FontWeight.w500)),
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      StarRating(rating: expert.rating, showCount: false, starSize: 13),
                      const SizedBox(width: 4),
                      Text('${expert.rating}', style: AppTextStyles.bodySmall(context).copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 8),
                      Text('${expert.consultations} পরামর্শ', style: AppTextStyles.bodySmall(context)),
                      const Spacer(),
                      Text('৳${expert.pricePerSession}', style: AppTextStyles.price(context).copyWith(fontSize: 14)),
                      Text('/সেশন', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (expert.available)
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.bookConsultation, arguments: expert),
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                      child: const Text('পরামর্শ বুক করুন'),
                    )
                  else
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
                      child: const Text('নোটিফাই করুন'),
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
