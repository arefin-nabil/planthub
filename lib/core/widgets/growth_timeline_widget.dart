import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class GrowthTimelineWidget extends StatefulWidget {
  final String plantName;

  const GrowthTimelineWidget({super.key, required this.plantName});

  @override
  State<GrowthTimelineWidget> createState() => _GrowthTimelineWidgetState();
}

class _GrowthTimelineWidgetState extends State<GrowthTimelineWidget> {
  int _selectedDayIndex = 1; // default to Day 30

  final List<Map<String, dynamic>> _milestones = [
    {
      'day': 'Day 1',
      'title': 'ডেলিভারি দিন',
      'desc': 'নার্সারি পলিব্যাগ থেকে নতুন টবে স্থাপন। সুস্থ সতেজ কচি পাতা।',
      'imageUrl': 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?w=500&q=80',
    },
    {
      'day': 'Day 30',
      'title': '১ মাস পর',
      'desc': 'নতুন ২টি শাখা ও গাঢ় সবুজ পাতা দেখা দিয়েছে। চমৎকার বৃদ্ধি।',
      'imageUrl': 'https://images.unsplash.com/photo-1518335935020-cfd6580c1ab4?w=500&q=80',
    },
    {
      'day': 'Day 90',
      'title': '৩ মাস পর',
      'desc': 'সম্পূর্ণ পরিণত ও ঘন পাতা। বারান্দার সৌন্দর্য দ্বিগুণ বৃদ্ধি পেয়েছে!',
      'imageUrl': 'https://images.unsplash.com/photo-1463154545680-d59320fd685d?w=500&q=80',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final current = _milestones[_selectedDayIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.timeline_rounded, color: AppColors.primaryGreen, size: 18),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('বাস্তব গ্রোথ টাইমলাইন', style: AppTextStyles.h3(context).copyWith(fontSize: 14)),
                    Text('ভেরিফাইড ক্রেতাদের আসল গাছের বৃদ্ধির অগ্রগতি', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('১০০% আসল', style: TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Day Selector Tabs
          Row(
            children: List.generate(_milestones.length, (index) {
              final isSelected = _selectedDayIndex == index;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  child: Container(
                    margin: EdgeInsets.only(right: index < _milestones.length - 1 ? 8 : 0),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : (isDark ? AppColors.darkSurface : AppColors.softWhite),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _milestones[index]['day'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppColors.naturalGray,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),

          // Photo & Details
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: current['imageUrl'],
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: Colors.grey[200]),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.85)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          current['title'],
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          current['desc'],
                          style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
