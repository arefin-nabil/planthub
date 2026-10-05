import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/plant_card.dart';
import '../../../core/widgets/faceted_filter_sheet.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../provider/marketplace_provider.dart';

import '../../../app/routes.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mp = context.watch<MarketplaceProvider>();
    final plants = mp.filteredPlants;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'গাছ এক্সপ্লোর',
        subtitle: '${plants.length}টি গাছ পাওয়া গেছে',
        showBackButton: Navigator.canPop(context),
        actions: [
          AppBarActionButton(
            icon: Icons.tune_rounded,
            badgeCount: mp.activeFilterCount,
            tooltip: 'ফিল্টার',
            onTap: () => FacetedFilterSheet.show(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => context.read<MarketplaceProvider>().setSearchQuery(v),
              decoration: InputDecoration(
                hintText: 'গাছের নাম, ক্যাটাগরি খুঁজুন... (মানি প্ল্যান্ট, গোলাপ)',
                prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primaryGreen),
                suffixIcon: mp.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => context.read<MarketplaceProvider>().setSearchQuery(''),
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.softWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Category Chips Bar
          SizedBox(
            height: 38,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: MarketplaceProvider.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = MarketplaceProvider.categories[index];
                final isSelected = mp.selectedCategory == cat;
                return GestureDetector(
                  onTap: () => context.read<MarketplaceProvider>().setCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryGreen : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
                      ),
                    ),
                    child: Text(
                      cat,
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
          const SizedBox(height: 8),

          // Result header & Sorting Trigger
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${plants.length}টি গাছ পাওয়া গেছে',
                  style: AppTextStyles.bodySmall(context).copyWith(fontWeight: FontWeight.w600),
                ),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (ctx) => _SortSheet(
                        currentSort: mp.sortBy,
                        onSelect: (sort) {
                          context.read<MarketplaceProvider>().setSortBy(sort);
                          Navigator.pop(ctx);
                        },
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sort_rounded, size: 14, color: AppColors.primaryGreen),
                        const SizedBox(width: 4),
                        Text(
                          mp.sortBy.labelBn,
                          style: AppTextStyles.label(context).copyWith(color: AppColors.primaryGreen, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: plants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 64, color: AppColors.naturalGray),
                        const SizedBox(height: 12),
                        Text('কোনো গাছ পাওয়া যায়নি', style: AppTextStyles.h2(context).copyWith(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('অনুসন্ধান বা ফিল্টারের শর্ত পরিবর্তন করে আবার চেষ্টা করুন', style: AppTextStyles.bodySmall(context)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<MarketplaceProvider>().resetFilters(),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
                          child: const Text('সব ফিল্টার মুছুন', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: plants.length,
                    itemBuilder: (context, index) => PlantCard(
                      plant: plants[index],
                      width: double.infinity,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: plants[index]),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final PlantSortBy currentSort;
  final ValueChanged<PlantSortBy> onSelect;

  const _SortSheet({required this.currentSort, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('সাজানোর নিয়ম', style: AppTextStyles.h2(context).copyWith(fontSize: 16)),
            const SizedBox(height: 12),
            ...PlantSortBy.values.map((sort) {
              final isSelected = sort == currentSort;
              return ListTile(
                title: Text(sort.labelBn),
                trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.primaryGreen) : null,
                onTap: () => onSelect(sort),
              );
            }),
          ],
        ),
      ),
    );
  }
}


/// Compatibility typedef
typedef ExploreScreen = ExplorePage;
