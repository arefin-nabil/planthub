import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // ── Display ─────────────────────────────────────────────────────────────────
  static TextStyle displayLarge(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.25,
      );

  static TextStyle displayMedium(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.25,
      );

  // ── Headings ─────────────────────────────────────────────────────────────────
  static TextStyle h1(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.3,
      );

  static TextStyle h2(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.35,
      );

  static TextStyle h3(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.35,
      );

  // ── Body ─────────────────────────────────────────────────────────────────────
  static TextStyle bodyLarge(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.5,
      );

  static TextStyle bodyMedium(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface,
        height: 1.5,
      );

  static TextStyle bodySmall(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.4,
      );

  // ── Price / Numeric (Using Inter with tabular numbers & Terracotta accent) ──
  static TextStyle price(BuildContext context) => GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w700,
        color: AppColors.terracotta,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle priceLarge(BuildContext context) => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: AppColors.terracotta,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  static TextStyle priceStrikethrough(BuildContext context) =>
      GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.naturalGray,
        decoration: TextDecoration.lineThrough,
        fontFeatures: const [FontFeature.tabularFigures()],
      );

  // ── Label / Caption ──────────────────────────────────────────────────────────
  static TextStyle label(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: AppColors.naturalGray,
        letterSpacing: 0.3,
      );

  static TextStyle badge(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.textOnGreen,
        letterSpacing: 0.3,
      );

  // ── Button ───────────────────────────────────────────────────────────────────
  static TextStyle button(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      );

  // ── Section header ───────────────────────────────────────────────────────────
  static TextStyle sectionTitle(BuildContext context) => GoogleFonts.hindSiliguri(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
