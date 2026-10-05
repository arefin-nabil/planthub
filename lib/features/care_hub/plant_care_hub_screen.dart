import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/extensions/context_x.dart';
import '../../core/widgets/app_top_bar.dart';

class PlantCareHubScreen extends StatefulWidget {
  const PlantCareHubScreen({super.key});

  @override
  State<PlantCareHubScreen> createState() => _PlantCareHubScreenState();
}

class _PlantCareHubScreenState extends State<PlantCareHubScreen> {
  bool _alertDismissed = false;

  // Collection of user's personal plants (Matching Stitch Sobujayon Care Hub)
  final List<Map<String, dynamic>> _myPlants = [
    {
      'id': 'my-1',
      'name': 'Aloe Vera',
      'nameBn': 'অ্যালোভেরা',
      'location': 'বারান্দা • মাটির টব',
      'image': 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?w=400&q=80',
      'intervalDays': 7,
      'daysRemaining': 0, // due today!
      'waterAmount': '২০০ মিলি',
      'drynessPercent': 95,
      'isWateredToday': false,
    },
    {
      'id': 'my-2',
      'name': 'Monstera Deliciosa',
      'nameBn': 'মনস্টেরা ডেলিসিওসা',
      'location': 'লিভিং রুম • সিরামিক টব',
      'image': 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=400&q=80',
      'intervalDays': 7,
      'daysRemaining': 0, // due today
      'waterAmount': '৩৫০ মিলি',
      'drynessPercent': 90,
      'isWateredToday': false,
    },
    {
      'id': 'my-3',
      'name': 'Fiddle Leaf Fig',
      'nameBn': 'ফিডল লিফ ফিগ',
      'location': 'বারান্দা • টেরাকোটা টব',
      'image': 'https://images.unsplash.com/photo-1593691509543-c55fb32e7355?w=400&q=80',
      'intervalDays': 5,
      'daysRemaining': 2,
      'waterAmount': '২৫০ মিলি',
      'drynessPercent': 60,
      'isWateredToday': false,
    },
    {
      'id': 'my-4',
      'name': 'Snake Plant',
      'nameBn': 'স্নেক প্ল্যান্ট',
      'location': 'রিডিং টেবিল • কনক্রিট টব',
      'image': 'https://images.unsplash.com/photo-1509423350716-97f9360b4e09?w=400&q=80',
      'intervalDays': 14,
      'daysRemaining': 8,
      'waterAmount': '১৫০ মিলি',
      'drynessPercent': 30,
      'isWateredToday': false,
    },
  ];

  void _markWatered(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      final plant = _myPlants[index];
      plant['daysRemaining'] = plant['intervalDays'];
      plant['drynessPercent'] = 10;
      plant['isWateredToday'] = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.water_drop_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text('🎉 ${_myPlants[index]['nameBn']} গাছে পানি দেওয়া সম্পন্ন হয়েছে!'),
            ),
          ],
        ),
        backgroundColor: AppColors.sobujayonPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showAddPlantDialog() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = context.isDark;
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('নতুন গাছ যুক্ত করুন', style: AppTextStyles.h2(context)),
                const SizedBox(height: 6),
                Text('আপনার বাড়ির গাছের যত্ন ও পানির রিমাইন্ডার সেট করুন', style: AppTextStyles.bodySmall(context)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'গাছের নাম (যেমন: মানি প্ল্যান্ট)',
                    prefixIcon: Icon(Icons.eco_rounded, color: AppColors.sobujayonSecondary),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(
                    labelText: 'অবস্থান (যেমন: বারান্দা, লিভিং রুম)',
                    prefixIcon: Icon(Icons.room_rounded, color: AppColors.sobujayonSecondary),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sobujayonPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                    ),
                    onPressed: () {
                      if (nameController.text.trim().isNotEmpty) {
                        setState(() {
                          _myPlants.insert(0, {
                            'id': 'my-${DateTime.now().millisecondsSinceEpoch}',
                            'name': nameController.text.trim(),
                            'nameBn': nameController.text.trim(),
                            'location': locationController.text.trim().isEmpty ? 'ঘরের কোণে' : locationController.text.trim(),
                            'image': 'https://images.unsplash.com/photo-1545241047-6083a3684587?w=400&q=80',
                            'intervalDays': 5,
                            'daysRemaining': 5,
                            'waterAmount': '২৫০ মিলি',
                            'drynessPercent': 15,
                            'isWateredToday': true,
                          });
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('নতুন গাছ সফলভাবে তালিকায় যুক্ত হয়েছে!'),
                            backgroundColor: AppColors.sobujayonPrimary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        );
                      }
                    },
                    child: const Text('তালিকায় যুক্ত করুন'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final duePlants = _myPlants.where((p) => p['daysRemaining'] == 0 && !p['isWateredToday']).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.sobujayonSurface,
      appBar: PlantHubAppBar(
        title: 'যত্ন কেন্দ্র',
        subtitle: 'Sobujayon Plant Care Hub',
        showBackButton: false,
        actions: [
          AppBarActionButton(
            icon: Icons.add_rounded,
            tooltip: 'নতুন গাছ যুক্ত করুন',
            onTap: _showAddPlantDialog,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // 1. Stitch Interactive Alert Banner
          if (!_alertDismissed && duePlants.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.sobujayonTertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_active_rounded, color: AppColors.sobujayonOnTertiaryContainer, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'যত্ন তাগিদ • অ্যালার্ট',
                                  style: TextStyle(
                                    color: AppColors.sobujayonOnTertiaryContainer,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  'এখনই',
                                  style: TextStyle(color: Color(0xFF717973), fontSize: 11),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.white : AppColors.sobujayonPrimary,
                                  height: 1.4,
                                ),
                                children: [
                                  const TextSpan(text: 'আপনার '),
                                  TextSpan(
                                    text: duePlants.first['nameBn'],
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                  const TextSpan(text: ' গাছে পানি দেওয়ার সময় হয়েছে! আর্দ্রতা দ্রুত কমে আসছে।'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _alertDismissed = true),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF717973),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        ),
                        child: const Text('পরে মনে করান', style: TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () {
                          final plantIdx = _myPlants.indexOf(duePlants.first);
                          if (plantIdx != -1) _markWatered(plantIdx);
                        },
                        icon: const Icon(Icons.water_drop_rounded, size: 16),
                        label: const Text('পানি দিয়েছি', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.sobujayonSecondary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // 2. Stitch Wellness Dashboard Header & Quick Stat Chips
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ওয়েলনেস ড্যাশবোর্ড',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.sobujayonSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'আমার সবুজ কানন',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.sobujayonPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.yard_outlined, color: AppColors.sobujayonSecondary, size: 22),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Quick Stat Chips (Horizontal scrollable)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickStatChip(
                  isDark: isDark,
                  dotColor: AppColors.sobujayonSecondary,
                  label: '${_myPlants.length}টি সুস্থ গাছ',
                ),
                const SizedBox(width: 8),
                _buildQuickStatChip(
                  isDark: isDark,
                  dotColor: AppColors.sobujayonOnTertiaryContainer,
                  label: 'আজকের কাজ: ${duePlants.length}টি বাকি',
                ),
                const SizedBox(width: 8),
                _buildQuickStatChip(
                  isDark: isDark,
                  icon: Icons.eco_rounded,
                  iconColor: AppColors.sobujayonSecondary,
                  label: 'আর্দ্রতা: সন্তোষজনক',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 3. Circular Hydration Tracker Bento Card (Stitch Sobujayon Specification)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'সাপ্তাহিক সূচক',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.sobujayonSecondary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'হাইড্রেশন স্কোর',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.sobujayonPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'আপনার গাছের সামগ্রিক আর্দ্রতা আদর্শ সীমায় আছে। পাতাগুলোর স্বাভাবিক সতেজতা বজায় রয়েছে।',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white70 : const Color(0xFF607268),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: const [
                          Icon(Icons.verified_rounded, size: 16, color: AppColors.sobujayonSecondary),
                          SizedBox(width: 6),
                          Text(
                            '৮৫% সন্তোষজনক পরিচর্যা',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.sobujayonSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Circular Gauge
                SizedBox(
                  width: 96,
                  height: 96,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 96,
                        height: 96,
                        child: CircularProgressIndicator(
                          value: 0.85,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          backgroundColor: isDark
                              ? Colors.white10
                              : AppColors.sobujayonSurfaceContainerHigh,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.sobujayonSecondary),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            '৮৫%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.sobujayonPrimary,
                            ),
                          ),
                          Text(
                            'আর্দ্রতা',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF717973),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. Section Header: আপনার গাছগুলো (Your Plants)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'আপনার গাছগুলো',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.sobujayonPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.sobujayonSecondaryContainer,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      '${_myPlants.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.sobujayonOnSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'পানির শিডিউল ট্র্যাকার',
                style: TextStyle(fontSize: 12, color: Color(0xFF607268)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 5. Plant Routine List matching Stitch Sobujayon specifications
          ...List.generate(_myPlants.length, (index) {
            final plant = _myPlants[index];
            final int dryness = plant['drynessPercent'] ?? 50;
            final bool isDue = (plant['daysRemaining'] == 0 && !plant['isWateredToday']);

            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Thumbnail
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedNetworkImage(
                              imageUrl: plant['image'],
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.yard_outlined, size: 12, color: AppColors.sobujayonSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    plant['nameBn'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: isDark ? Colors.white : AppColors.sobujayonPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDue
                                        ? AppColors.sobujayonTertiaryContainer.withValues(alpha: 0.4)
                                        : AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    isDue ? 'আজকের কাজ' : '${plant['daysRemaining']} দিন বাকি',
                                    style: TextStyle(
                                      color: isDue ? AppColors.sobujayonOnTertiaryContainer : AppColors.sobujayonSecondary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              plant['location'],
                              style: const TextStyle(fontSize: 11, color: Color(0xFF717973)),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.water_drop_outlined, size: 13, color: AppColors.sobujayonSecondary),
                                const SizedBox(width: 4),
                                Text(
                                  'পরিমাণ: ${plant['waterAmount']}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF607268)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Terracotta Progress Bar & Water Action
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'পরবর্তী পানি সেচ',
                                  style: TextStyle(fontSize: 11, color: Color(0xFF717973)),
                                ),
                                Text(
                                  '$dryness% শুষ্ক',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isDue ? AppColors.sobujayonOnTertiaryContainer : AppColors.sobujayonSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(9999),
                              child: LinearProgressIndicator(
                                value: dryness / 100,
                                minHeight: 6,
                                backgroundColor: isDark
                                    ? Colors.white10
                                    : AppColors.sobujayonSurfaceContainerHigh,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isDue
                                      ? AppColors.sobujayonOnTertiaryContainer
                                      : AppColors.sobujayonSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Quick Water Checkmark Button
                      GestureDetector(
                        onTap: () => _markWatered(index),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: plant['isWateredToday']
                                ? AppColors.sobujayonSecondary
                                : (isDark ? AppColors.darkBorder : AppColors.sobujayonSurfaceContainerLow),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            size: 20,
                            color: plant['isWateredToday']
                                ? Colors.white
                                : (isDark ? Colors.white70 : AppColors.sobujayonSecondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuickStatChip({
    required bool isDark,
    Color? dotColor,
    IconData? icon,
    Color? iconColor,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.sobujayonPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
