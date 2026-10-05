import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../providers/nursery_provider.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nursery = context.watch<NurseryProvider>();
    final inventory = nursery.filteredInventory;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('ইনভেন্টরি (${nursery.totalProducts}টি আইটেম)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => nursery.setInventorySearch(''),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Low-stock summary banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              onChanged: (v) => nursery.setInventorySearch(v),
              decoration: InputDecoration(
                hintText: 'ইনভেন্টরিতে গাছ খুঁজুন...',
                prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.primaryGreen),
                isDense: true,
                filled: true,
                fillColor: isDark ? AppColors.darkCard : AppColors.softWhite,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),

          // Low Stock Alert Banner
          if (nursery.lowStockCount > 0 || nursery.outOfStockCount > 0)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                border: Border.all(color: AppColors.warning.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'সতর্কতা: ${nursery.lowStockCount}টি গাছের স্টক কম এবং ${nursery.outOfStockCount}টি গাছের স্টক শেষ!',
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Table header
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppConstants.radiusMd)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('গাছের নাম', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 3, child: Text('স্টক নিয়ন্ত্রণ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text('স্ট্যাটাস', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
              ],
            ),
          ),

          // Table rows
          Expanded(
            child: inventory.isEmpty
                ? const Center(child: Text('কোনো গাছ খুঁজে পাওয়া যায়নি'))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: inventory.length,
                    itemBuilder: (context, index) {
                      final item = inventory[index];
                      final isOut = item.isOutOfStock;
                      final isLow = item.isLowStock;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: index.isEven
                              ? Theme.of(context).cardTheme.color
                              : AppColors.primaryGreen.withOpacity(0.02),
                          border: Border(
                            bottom: BorderSide(color: AppColors.lightBorder, width: 0.5),
                            left: BorderSide(color: AppColors.lightBorder, width: 0.5),
                            right: BorderSide(color: AppColors.lightBorder, width: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            // Plant title
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.plant.nameBn,
                                    style: AppTextStyles.bodyMedium(context).copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '৳${item.plant.price.toInt()}',
                                    style: TextStyle(fontSize: 10, color: AppColors.naturalGray),
                                  ),
                                ],
                              ),
                            ),

                            // Quick +/- buttons
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                                    color: item.stock > 0 ? AppColors.error : Colors.grey,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                    onPressed: item.stock > 0
                                        ? () => nursery.updateStock(item.plant.id, -1)
                                        : null,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 6),
                                    child: Text(
                                      '${item.stock}',
                                      style: AppTextStyles.h3(context).copyWith(
                                        fontSize: 14,
                                        color: isOut ? AppColors.error : isLow ? AppColors.warning : null,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline_rounded, size: 20, color: AppColors.primaryGreen),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(minWidth: 26, minHeight: 26),
                                    onPressed: () => nursery.updateStock(item.plant.id, 1),
                                  ),
                                ],
                              ),
                            ),

                            // Status badge
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: (isOut ? AppColors.error : isLow ? AppColors.warning : AppColors.success).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    isOut ? 'স্টক শেষ' : isLow ? 'কম স্টক' : 'মজুদ আছে',
                                    style: TextStyle(
                                      color: isOut ? AppColors.error : isLow ? AppColors.warning : AppColors.success,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}


/// Compatibility typedef
typedef InventoryScreen = InventoryPage;
