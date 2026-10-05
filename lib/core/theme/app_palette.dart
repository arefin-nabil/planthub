import 'package:flutter/material.dart';
import 'app_colors.dart';

/// ThemeExtension to eliminate redundant `isDark ? ... : ...` logic across the UI.
/// Accessible via `context.palette` through [ContextX].
class AppPalette extends ThemeExtension<AppPalette> {
  final Color accentSale;
  final Color accentSaleSurface;
  final Color accentPremium;
  final Color accentPremiumSurface;
  final Color cardBorder;
  final Color subtleBackground;
  final Color searchBarFill;
  final Color shimmerBase;
  final Color shimmerHighlight;
  final Color bKash;
  final Color nagad;

  const AppPalette({
    required this.accentSale,
    required this.accentSaleSurface,
    required this.accentPremium,
    required this.accentPremiumSurface,
    required this.cardBorder,
    required this.subtleBackground,
    required this.searchBarFill,
    required this.shimmerBase,
    required this.shimmerHighlight,
    required this.bKash,
    required this.nagad,
  });

  static const light = AppPalette(
    accentSale: AppColors.terracotta,
    accentSaleSurface: AppColors.terracottaLight,
    accentPremium: AppColors.goldAccent,
    accentPremiumSurface: AppColors.goldLight,
    cardBorder: AppColors.lightBorder,
    subtleBackground: Color(0xFFF3F5F1),
    searchBarFill: Colors.white,
    shimmerBase: Color(0xFFE8EAE6),
    shimmerHighlight: Color(0xFFF7F8F6),
    bKash: AppColors.bKashPink,
    nagad: AppColors.nagadOrange,
  );

  static const dark = AppPalette(
    accentSale: Color(0xFFE58A62),
    accentSaleSurface: Color(0xFF2C1E18),
    accentPremium: Color(0xFFD4B24A),
    accentPremiumSurface: Color(0xFF2A2414),
    cardBorder: AppColors.darkBorder,
    subtleBackground: AppColors.darkSurface,
    searchBarFill: AppColors.darkCard,
    shimmerBase: Color(0xFF1E2622),
    shimmerHighlight: Color(0xFF28342D),
    bKash: AppColors.bKashPink,
    nagad: AppColors.nagadOrange,
  );

  @override
  ThemeExtension<AppPalette> copyWith({
    Color? accentSale,
    Color? accentSaleSurface,
    Color? accentPremium,
    Color? accentPremiumSurface,
    Color? cardBorder,
    Color? subtleBackground,
    Color? searchBarFill,
    Color? shimmerBase,
    Color? shimmerHighlight,
    Color? bKash,
    Color? nagad,
  }) {
    return AppPalette(
      accentSale: accentSale ?? this.accentSale,
      accentSaleSurface: accentSaleSurface ?? this.accentSaleSurface,
      accentPremium: accentPremium ?? this.accentPremium,
      accentPremiumSurface: accentPremiumSurface ?? this.accentPremiumSurface,
      cardBorder: cardBorder ?? this.cardBorder,
      subtleBackground: subtleBackground ?? this.subtleBackground,
      searchBarFill: searchBarFill ?? this.searchBarFill,
      shimmerBase: shimmerBase ?? this.shimmerBase,
      shimmerHighlight: shimmerHighlight ?? this.shimmerHighlight,
      bKash: bKash ?? this.bKash,
      nagad: nagad ?? this.nagad,
    );
  }

  @override
  ThemeExtension<AppPalette> lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      accentSale: Color.lerp(accentSale, other.accentSale, t)!,
      accentSaleSurface: Color.lerp(accentSaleSurface, other.accentSaleSurface, t)!,
      accentPremium: Color.lerp(accentPremium, other.accentPremium, t)!,
      accentPremiumSurface: Color.lerp(accentPremiumSurface, other.accentPremiumSurface, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      subtleBackground: Color.lerp(subtleBackground, other.subtleBackground, t)!,
      searchBarFill: Color.lerp(searchBarFill, other.searchBarFill, t)!,
      shimmerBase: Color.lerp(shimmerBase, other.shimmerBase, t)!,
      shimmerHighlight: Color.lerp(shimmerHighlight, other.shimmerHighlight, t)!,
      bKash: Color.lerp(bKash, other.bKash, t)!,
      nagad: Color.lerp(nagad, other.nagad, t)!,
    );
  }
}
