import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../features/marketplace/provider/marketplace_provider.dart';


class FacetedFilterSheet extends StatefulWidget {
  const FacetedFilterSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FacetedFilterSheet(),
    );
  }

  @override
  State<FacetedFilterSheet> createState() => _FacetedFilterSheetState();
}

class _FacetedFilterSheetState extends State<FacetedFilterSheet> {
  late String _category;
  late String _sunlight;
  late String _water;
  late String _careLevel;
  late bool _verifiedOnly;
  late RangeValues _priceRange;

  @override
  void initState() {
    super.initState();
    final mp = context.read<MarketplaceProvider>();
    _category = mp.selectedCategory;
    _sunlight = mp.selectedSunlight;
    _water = mp.selectedWater;
    _careLevel = mp.selectedCareLevel;
    _verifiedOnly = mp.verifiedOnly;
    _priceRange = mp.priceRange;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.82,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text('ফিল্টার এবং সাজান', style: AppTextStyles.h2(context).copyWith(fontSize: 18)),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _category = 'সব';
                      _sunlight = 'সব';
                      _water = 'সব';
                      _careLevel = 'সব';
                      _verifiedOnly = false;
                      _priceRange = const RangeValues(0, 5000);
                    });
                  },
                  child: const Text('রিসেট', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Scrollable Filter Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // Category Filter
                _buildSectionTitle('ক্যাটাগরি'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: MarketplaceProvider.categories.map((cat) {
                    final selected = _category == cat;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.textPrimary),
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (_) => setState(() => _category = cat),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Sunlight Filter
                _buildSectionTitle('সূর্যালোকের প্রয়োজন'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: MarketplaceProvider.sunlightOptions.map((opt) {
                    final selected = _sunlight == opt;
                    return ChoiceChip(
                      avatar: opt == 'সব' ? null : const Icon(Icons.wb_sunny_rounded, size: 14),
                      label: Text(opt),
                      selected: selected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.textPrimary),
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (_) => setState(() => _sunlight = opt),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Watering Filter
                _buildSectionTitle('পানি দেওয়ার নিয়ম'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: MarketplaceProvider.waterOptions.map((opt) {
                    final selected = _water == opt;
                    return ChoiceChip(
                      avatar: opt == 'সব' ? null : const Icon(Icons.water_drop_rounded, size: 14),
                      label: Text(opt),
                      selected: selected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.textPrimary),
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (_) => setState(() => _water = opt),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Care Level
                _buildSectionTitle('যত্নের ধরন'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: MarketplaceProvider.careLevelOptions.map((opt) {
                    final selected = _careLevel == opt;
                    return ChoiceChip(
                      label: Text(opt),
                      selected: selected,
                      selectedColor: AppColors.primaryGreen,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : (isDark ? Colors.white70 : AppColors.textPrimary),
                        fontSize: 12,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                      ),
                      onSelected: (_) => setState(() => _careLevel = opt),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Price Range Slider
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle('মূল্য পরিসীমা'),
                    Text(
                      '৳${_priceRange.start.round()} - ৳${_priceRange.end.round()}',
                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryGreen),
                    ),
                  ],
                ),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 5000,
                  divisions: 50,
                  activeColor: AppColors.primaryGreen,
                  inactiveColor: AppColors.lightGreen.withOpacity(0.3),
                  onChanged: (vals) => setState(() => _priceRange = vals),
                ),
                const SizedBox(height: 12),

                // Verified Switch
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('শুধুমাত্র ভেরিফাইড নার্সারি', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: const Text('১০০% আসল গাছ ও সঠিক যত্নের গ্যারান্টি', style: TextStyle(fontSize: 11)),
                  value: _verifiedOnly,
                  activeColor: AppColors.primaryGreen,
                  onChanged: (val) => setState(() => _verifiedOnly = val),
                ),
              ],
            ),
          ),

          // Bottom Apply Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () {
                  final mp = context.read<MarketplaceProvider>();
                  mp.setCategory(_category);
                  mp.setSunlight(_sunlight);
                  mp.setWater(_water);
                  mp.setCareLevel(_careLevel);
                  if (mp.verifiedOnly != _verifiedOnly) mp.toggleVerifiedOnly();
                  mp.setPriceRange(_priceRange);
                  Navigator.pop(context);
                },
                child: const Text('ফিল্টার প্রয়োগ করুন', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.naturalGray),
      ),
    );
  }
}
