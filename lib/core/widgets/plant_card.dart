import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../../data/mock/mock_data.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';

/// Premium plant product card used across marketplace & explore screens
class PlantCard extends StatefulWidget {
  final MockPlant plant;
  final VoidCallback? onTap;
  final double? width;

  const PlantCard({
    super.key,
    required this.plant,
    this.onTap,
    this.width,
  });

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.96,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _scaleController;
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _scaleController.reverse().then((_) {
      _scaleController.forward();
      widget.onTap?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardWidth = widget.width ?? AppConstants.productCardWidth;

    // Listen to wishlist status reactively
    final wishlistProvider = context.watch<WishlistProvider>();
    final isWishlisted = wishlistProvider.isWishlisted(widget.plant.id);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: (_) => _scaleController.reverse(),
        onTapCancel: () => _scaleController.forward(),
        child: SizedBox(
          width: cardWidth,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE8EFEA),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF012D1D).withValues(alpha: isDark ? 0.2 : 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Section (Aspect Ratio 4/5)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
                  child: Container(
                    color: isDark ? AppColors.darkSurface : AppColors.sobujayonSurfaceContainerLow,
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 4 / 5,
                          child: CachedNetworkImage(
                            imageUrl: widget.plant.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: isDark ? AppColors.darkCard : Colors.grey[200]!,
                              highlightColor: isDark ? AppColors.darkBorder : Colors.grey[100]!,
                              child: Container(color: Colors.white),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.lightGreen.withValues(alpha: 0.2),
                              child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 36),
                            ),
                          ),
                        ),
                        // Floating Frosted Wishlist Button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => wishlistProvider.toggleWishlist(widget.plant),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: (isDark ? AppColors.darkCard : Colors.white).withValues(alpha: 0.85),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(
                                isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isWishlisted ? AppColors.error : AppColors.sobujayonPrimary,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        // Bottom-Left Botanical Attribute Chip
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: (isDark ? AppColors.darkCard : Colors.white).withValues(alpha: 0.90),
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.06),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  widget.plant.sunlight.contains('রোদ') || widget.plant.sunlight.contains('আলো')
                                      ? Icons.wb_sunny_outlined
                                      : (widget.plant.water.contains('কম')
                                          ? Icons.water_drop_outlined
                                          : Icons.filter_vintage_outlined),
                                  size: 11,
                                  color: AppColors.sobujayonSecondary,
                                ),
                                const SizedBox(width: 3.5),
                                Text(
                                  widget.plant.category == 'ইনডোর'
                                      ? 'সেরা নির্বাচন'
                                      : (widget.plant.sunlight.isNotEmpty ? widget.plant.sunlight : 'সহজ যত্ন'),
                                  style: const TextStyle(
                                    color: AppColors.sobujayonPrimary,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Discount Badge
                        if (widget.plant.originalPrice != null)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '-${((1 - widget.plant.price / widget.plant.originalPrice!) * 100).round()}%',
                                style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Info Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nursery Tag
                      Row(
                        children: [
                          const Icon(Icons.storefront_rounded, size: 12, color: AppColors.sobujayonSecondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.plant.nurseryName,
                              style: const TextStyle(
                                color: AppColors.sobujayonSecondary,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Plant Species Name (Bengali)
                      Text(
                        widget.plant.nameBn,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Vessel / Pot pairing subtitle
                      Text(
                        'সিরামিক টব সহ',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isDark ? AppColors.textDarkSecondary : const Color(0xFF607268),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Price and Quick Add-to-cart row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.plant.originalPrice != null)
                                Text(
                                  '৳${widget.plant.originalPrice!.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.naturalGray,
                                  ),
                                ),
                              Text(
                                '৳${widget.plant.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.sobujayonOnTertiaryContainer,
                                ),
                              ),
                            ],
                          ),
                          // Floating Add to Cart Pill Button
                          GestureDetector(
                            onTap: () {
                              context.read<CartProvider>().addItem(widget.plant, quantity: 1);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text('${widget.plant.nameBn} ব্যাগে যোগ করা হয়েছে!'),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 2),
                                  backgroundColor: AppColors.sobujayonPrimary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            },
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.sobujayonPrimary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.sobujayonPrimary.withValues(alpha: 0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
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
        ),
      ),
    );
  }
}
