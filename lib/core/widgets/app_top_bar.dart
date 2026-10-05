import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../extensions/context_x.dart';

/// Standardized, consistent luxury botanical AppBar for all PlantHub screens.
/// Enforces consistent height, back button treatment, typography, and actions.
class PlantHubAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final String? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final bool centerTitle;

  const PlantHubAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
    this.bottom,
    this.backgroundColor,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    final isDark = context.isDark;

    Widget? effectiveLeading = leading;
    if (effectiveLeading == null && showBackButton && canPop) {
      effectiveLeading = Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              if (onBackPressed != null) {
                onBackPressed!();
              } else {
                Navigator.maybePop(context);
              }
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 0.8,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      );
    }

    Widget? effectiveTitle = titleWidget;
    if (effectiveTitle == null && title != null) {
      if (subtitle != null && subtitle!.isNotEmpty) {
        effectiveTitle = Column(
          crossAxisAlignment:
              centerTitle ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title!,
              style: AppTextStyles.h2(context).copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              subtitle!,
              style: AppTextStyles.bodySmall(context).copyWith(
                fontSize: 11,
                color: isDark ? AppColors.textDarkSecondary : AppColors.naturalGray,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      } else {
        effectiveTitle = Text(
          title!,
          style: AppTextStyles.h2(context).copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }
    }

    return AppBar(
      backgroundColor: backgroundColor ??
          (isDark ? AppColors.darkBg : AppColors.softWhite),
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      leading: effectiveLeading,
      leadingWidth: (canPop && showBackButton) || leading != null ? 54 : 16,
      title: effectiveTitle,
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8),
            ]
          : null,
      bottom: bottom,
    );
  }
}

/// Unified square/squircle action button for AppBars
class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final int? badgeCount;
  final Color? iconColor;
  final String? tooltip;

  const AppBarActionButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.badgeCount,
    this.iconColor,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Tooltip(
        message: tooltip ?? '',
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 0.8,
              ),
              boxShadow: isDark
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: iconColor ??
                      (isDark ? AppColors.textDarkPrimary : AppColors.textPrimary),
                ),
                if (badgeCount != null && badgeCount! > 0)
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          badgeCount! > 99 ? '99+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
