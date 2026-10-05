import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/plant_card.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../provider/wishlist_provider.dart';

import '../../../app/routes.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final items = wishlist.items;

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'পছন্দের গাছ',
        subtitle: items.isNotEmpty ? '${items.length}টি গাছ সংরক্ষিত' : null,
        showBackButton: Navigator.canPop(context),
        actions: [
          if (items.isNotEmpty)
            AppBarActionButton(
              icon: Icons.delete_sweep_outlined,
              tooltip: 'সব মুছুন',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('উইশলিস্ট খালি করবেন?'),
                    content: const Text('আপনি কি নিশ্চিত যে উইশলিস্টের সব গাছ মুছে ফেলতে চান?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('না')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        onPressed: () {
                          wishlist.clearWishlist();
                          Navigator.pop(ctx);
                        },
                        child: const Text('মুছুন', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite_border_rounded, size: 64, color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  Text('উইশলিস্ট ফাঁকা', style: AppTextStyles.h2(context)),
                  const SizedBox(height: 8),
                  Text('পছন্দের গাছে ❤️ আইকনে ট্যাপ করে এখানে সংরক্ষণ করুন', style: AppTextStyles.bodyMedium(context)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, AppRoutes.explore),
                    icon: const Icon(Icons.search_rounded),
                    label: const Text('নতুন গাছ খুঁজুন'),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.65,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => PlantCard(
                plant: items[index],
                width: double.infinity,
                onTap: () => Navigator.pushNamed(context, AppRoutes.productDetail, arguments: items[index]),
              ),
            ),
    );
  }
}


/// Compatibility typedef
typedef WishlistScreen = WishlistPage;
