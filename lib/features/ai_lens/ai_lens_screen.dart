import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/extensions/context_x.dart';
import '../../core/widgets/app_top_bar.dart';
import '../../data/mock/mock_data.dart';
import '../../providers/cart_provider.dart';
import '../../app/routes.dart';

class AiLensScreen extends StatefulWidget {
  const AiLensScreen({super.key});

  @override
  State<AiLensScreen> createState() => _AiLensScreenState();
}

class _AiLensScreenState extends State<AiLensScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _isFlashOn = false;
  bool _isScanning = true;
  int _selectedDemoIndex = 0;

  // Sample AI detection targets for realistic interactive demo
  final List<Map<String, dynamic>> _demoPlants = [
    {
      'name': 'Monstera Deliciosa',
      'nameBn': 'মনস্টেরা ডেলিসিওসা',
      'scientificName': 'Monstera deliciosa Liebm.',
      'confidence': '৯৮%',
      'image': 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?w=600&q=80',
      'water': 'সপ্তাহে ১ বার',
      'sunlight': 'উজ্জ্বল পরোক্ষ আলো',
      'temp': '২০°-৩০° সে.',
      'description': 'ইনডোরের জন্য অত্যন্ত জনপ্রিয় ও দৃষ্টিনন্দন পাতাযুক্ত গাছ। কম যত্নেও ভালো থাকে।',
      'nurseries': [
        {'name': 'Green Valley Nursery', 'price': 850, 'rating': 4.9, 'verified': true},
        {'name': 'Dhaka Plant House', 'price': 820, 'rating': 4.7, 'verified': true},
        {'name': 'Bonsai & Bloom', 'price': 900, 'rating': 4.8, 'verified': true},
      ],
    },
    {
      'name': 'Peace Lily',
      'nameBn': 'পিস লিলি',
      'scientificName': 'Spathiphyllum wallisii',
      'confidence': '৯৬%',
      'image': 'https://images.unsplash.com/photo-1593691509543-c55fb32e7355?w=600&q=80',
      'water': 'মাটি শুকিয়ে গেলে',
      'sunlight': 'কম আলো / ছায়া',
      'temp': '১৮°-২৮° সে.',
      'description': 'বাতাস বিশুদ্ধকারী দারুণ ইনডোর গাছ। নিয়মিত সাদা ফুল ফোটে।',
      'nurseries': [
        {'name': 'Dhaka Plant House', 'price': 450, 'rating': 4.7, 'verified': true},
        {'name': 'Green Paradise', 'price': 480, 'rating': 4.9, 'verified': true},
      ],
    },
    {
      'name': 'Snake Plant',
      'nameBn': 'স্নেক প্ল্যান্ট',
      'scientificName': 'Sansevieria trifasciata',
      'confidence': '৯৯%',
      'image': 'https://images.unsplash.com/photo-1509423350716-97f9360b4e09?w=600&q=80',
      'water': '১০-১২ দিনে ১ বার',
      'sunlight': 'যে কোনো আলো',
      'temp': '১৫°-৩২° সে.',
      'description': 'রাতভর অক্সিজেন দেয় এবং খুব কম পানিতে বাঁচে। নতুনদের জন্য আদর্শ।',
      'nurseries': [
        {'name': 'Bonsai & Bloom', 'price': 380, 'rating': 4.8, 'verified': true},
        {'name': 'Green Valley Nursery', 'price': 400, 'rating': 4.9, 'verified': true},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _triggerScan() {
    HapticFeedback.heavyImpact();
    setState(() => _isScanning = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        setState(() => _isScanning = false);
        _showResultSheet(context);
      }
    });
  }

  void _showResultSheet(BuildContext context) {
    final plant = _demoPlants[_selectedDemoIndex];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.62,
        minChildSize: 0.40,
        maxChildSize: 0.90,
        builder: (context, scrollController) {
          final isDark = context.isDark;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Top Half: গাছটি চিনে নিন (Identify)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: plant['image'],
                        width: 76,
                        height: 76,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.sobujayonSecondaryContainer,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded, size: 13, color: AppColors.sobujayonOnSecondaryContainer),
                                const SizedBox(width: 4),
                                Text(
                                  '${plant['confidence']} নিশ্চিত মিল',
                                  style: const TextStyle(
                                    color: AppColors.sobujayonOnSecondaryContainer,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            plant['nameBn'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.sobujayonPrimary,
                            ),
                          ),
                          Text(
                            plant['scientificName'],
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 12,
                              color: Color(0xFF717973),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  plant['description'],
                  style: TextStyle(
                    color: isDark ? Colors.white70 : const Color(0xFF607268),
                    fontSize: 12.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),

                // Care Specs Grid
                Row(
                  children: [
                    _CareMiniTile(
                      icon: Icons.water_drop_rounded,
                      iconColor: AppColors.sobujayonSecondary,
                      label: plant['water'],
                      title: 'পানি',
                    ),
                    const SizedBox(width: 10),
                    _CareMiniTile(
                      icon: Icons.wb_sunny_rounded,
                      iconColor: AppColors.sobujayonOnTertiaryContainer,
                      label: plant['sunlight'],
                      title: 'সূর্যালোক',
                    ),
                    const SizedBox(width: 10),
                    _CareMiniTile(
                      icon: Icons.spa_rounded,
                      iconColor: AppColors.sobujayonPrimary,
                      label: 'সহজ যত্ন',
                      title: 'যত্ন মাত্রা',
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const Divider(),
                const SizedBox(height: 12),

                // Bottom Half: কিনতে পাওয়া যাচ্ছে এখানে (Nearby Nurseries)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.storefront_outlined, size: 18, color: AppColors.sobujayonSecondary),
                        SizedBox(width: 6),
                        Text(
                          'কিনতে পাওয়া যাচ্ছে এখানে',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.sobujayonPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        '${plant['nurseries'].length}টি নার্সারি কাছেই',
                        style: const TextStyle(
                          color: AppColors.sobujayonSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                ...List.generate(plant['nurseries'].length, (idx) {
                  final n = plant['nurseries'][idx];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.sobujayonSurfaceContainerLowest,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.darkBorder : AppColors.sobujayonSurfaceContainerHigh,
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.storefront_rounded, color: AppColors.sobujayonSecondary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    n['name'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13.5,
                                      color: AppColors.sobujayonPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified_rounded, size: 13, color: AppColors.sobujayonSecondary),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFA726)),
                                  const SizedBox(width: 2),
                                  Text('${n['rating']} · ১.২ কি.মি.', style: const TextStyle(fontSize: 11, color: Color(0xFF717973))),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'স্টকে আছে: ৩টি পাত্র',
                                style: TextStyle(fontSize: 10.5, color: AppColors.sobujayonSecondary, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '৳${n['price']}',
                              style: const TextStyle(
                                color: AppColors.sobujayonTertiary,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () {
                                final matched = MockData.plants.firstWhere(
                                  (p) => p.nameBn.contains(plant['nameBn']) || p.name.contains(plant['name']),
                                  orElse: () => MockData.plants.first,
                                );
                                context.read<CartProvider>().addItem(matched);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${plant['nameBn']} ব্যাগে যোগ করা হয়েছে!'),
                                    backgroundColor: AppColors.sobujayonPrimary,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.sobujayonPrimary,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Text(
                                      'অর্ডার',
                                      style: TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(Icons.arrow_forward_rounded, size: 12, color: Colors.white),
                                  ],
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
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPlant = _demoPlants[_selectedDemoIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Simulated Camera Feed (with high-res botanical photo)
          CachedNetworkImage(
            imageUrl: currentPlant['image'],
            fit: BoxFit.cover,
            placeholder: (_, __) => Container(color: Colors.black),
          ),

          // Camera Dark Vignette
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.6),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.25, 0.70, 1.0],
              ),
            ),
          ),

          // Scanning Reticle & Laser Beam
          SafeArea(
            child: Column(
              children: [
                // Top controls bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      _CircleGlassButton(
                        icon: Icons.close_rounded,
                        onTap: () {
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(9999),
                          border: Border.all(color: Colors.white30, width: 0.8),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: AppColors.sobujayonSecondaryFixed,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Text(
                              'এআই লেন্স সক্রিয়',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      _CircleGlassButton(
                        icon: _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                        onTap: () => setState(() => _isFlashOn = !_isFlashOn),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Central Focus Finder & Scanning Line with HUD tags
                Center(
                  child: SizedBox(
                    width: 290,
                    height: 290,
                    child: Stack(
                      children: [
                        // Reticle corners
                        _ReticleCorner(alignment: Alignment.topLeft),
                        _ReticleCorner(alignment: Alignment.topRight),
                        _ReticleCorner(alignment: Alignment.bottomLeft),
                        _ReticleCorner(alignment: Alignment.bottomRight),

                        // Floating Analytical Data HUD Tags (Matching Stitch Sobujayon Mock)
                        Positioned(
                          top: 40,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
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
                                Icon(Icons.psychology_outlined, size: 14, color: AppColors.sobujayonSecondary),
                                SizedBox(width: 4),
                                Text(
                                  'পাতা গঠন: ৯৮% মিল',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.sobujayonPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 72,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
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
                                Icon(Icons.water_drop_rounded, size: 13, color: AppColors.sobujayonOnTertiaryContainer),
                                SizedBox(width: 4),
                                Text(
                                  'আর্দ্রতা: সন্তোষজনক',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.sobujayonPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Animated Scanning Line
                        if (_scanController.isAnimating)
                          AnimatedBuilder(
                            animation: _scanController,
                            builder: (context, child) {
                              return Positioned(
                                top: 20 + _scanController.value * 240,
                                left: 16,
                                right: 16,
                                child: Container(
                                  height: 2.5,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        AppColors.sobujayonSecondaryFixed,
                                        Colors.white,
                                        AppColors.sobujayonSecondaryFixed,
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.sobujayonSecondaryFixed.withValues(alpha: 0.9),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // Live Scanning Status Chip
                        Positioned(
                          bottom: 12,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppColors.sobujayonPrimaryContainer.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.sync_rounded, size: 14, color: AppColors.sobujayonSecondaryFixed),
                                  SizedBox(width: 6),
                                  Text(
                                    'গাছ স্ক্যান হচ্ছে...',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Text(
                  'গাছের পাতা বা ফুলের কেন্দ্রে ক্যামেরা ফোকাস করুন',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12),
                ),

                const Spacer(),

                // Sample plant selector strip
                Container(
                  height: 44,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _demoPlants.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final isSelected = _selectedDemoIndex == i;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _selectedDemoIndex = i);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryGreen
                                : Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? AppColors.lightGreen : Colors.white24,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _demoPlants[i]['nameBn'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Shutter / Scan Action Button
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _CircleGlassButton(
                        icon: Icons.photo_library_outlined,
                        onTap: () => _triggerScan(),
                      ),
                      GestureDetector(
                        onTap: _triggerScan,
                        child: Container(
                          width: 76,
                          height: 76,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Color(0xFF52B788), AppColors.primaryGreen],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: const Icon(Icons.document_scanner_rounded, color: Colors.white, size: 30),
                          ),
                        ),
                      ),
                      _CircleGlassButton(
                        icon: Icons.info_outline_rounded,
                        onTap: () => _showResultSheet(context),
                      ),
                    ],
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

class _CircleGlassButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleGlassButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(22),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24, width: 0.8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _CareMiniTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String label;

  const _CareMiniTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.softWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 0.8,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(fontSize: 10, color: isDark ? Colors.white60 : Colors.black54),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReticleCorner extends StatelessWidget {
  final Alignment alignment;

  const _ReticleCorner({required this.alignment});

  @override
  Widget build(BuildContext context) {
    final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    const cornerColor = AppColors.sobujayonSecondaryFixed;

    return Align(
      alignment: alignment,
      child: Container(
        width: 32,
        height: 32,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: cornerColor.withValues(alpha: 0.5),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
          border: Border(
            top: isTop ? const BorderSide(color: cornerColor, width: 3.5) : BorderSide.none,
            bottom: !isTop ? const BorderSide(color: cornerColor, width: 3.5) : BorderSide.none,
            left: isLeft ? const BorderSide(color: cornerColor, width: 3.5) : BorderSide.none,
            right: !isLeft ? const BorderSide(color: cornerColor, width: 3.5) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
