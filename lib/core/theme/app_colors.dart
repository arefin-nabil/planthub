import 'package:flutter/material.dart';

/// PlantHub Bangladesh — Brand Color Tokens
/// "Calm Botanical Luxury" palette optimized for e-commerce
abstract class AppColors {
  // ── Primary Greens ─────────────────────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF2D6A4F); // Deep Forest Green (#2D6A4F)
  static const Color darkGreen = Color(0xFF1B4332);   // Deepest botanical emerald
  static const Color lightGreen = Color(0xFF52B788);
  static const Color forestGreen = Color(0xFF1B4332);
  static const Color leafAccent = Color(0xFF40916C);
  static const Color mintContainer = Color(0xFFD8F3DC);
  static const Color limeHighlight = Color(0xFF95D5B2);

  // ── Neutral / Background (Mint-tinted soft white #F9FBFA) ───────────────────
  static const Color softWhite = Color(0xFFF9FBFA); // Mint-tinted luxury white
  static const Color warmIvory = Color(0xFFF9FBFA);
  static const Color naturalGray = Color(0xFF6B706A);
  static const Color lightBorder = Color(0xFFE2E8E5);
  static const Color cardLight = Color(0xFFFFFFFF);

  // ── Dark Mode Surfaces (OLED-friendly neutral charcoal, subtle green hint) ──
  static const Color darkBg = Color(0xFF0F1412); // Neutral charcoal instead of over-saturated green
  static const Color darkSurface = Color(0xFF171D1A);
  static const Color darkCard = Color(0xFF1E2622);
  static const Color darkBorder = Color(0xFF2B3630);

  // ── Semantic ────────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);
  static const Color success = Color(0xFF2E7D32);
  static const Color info = Color(0xFF1976D2);

  // ── Text ────────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF161F1A);
  static const Color textSecondary = Color(0xFF6B706A);
  static const Color textOnGreen = Color(0xFFFFFFFF);
  static const Color textDarkPrimary = Color(0xFFF0F4F1);
  static const Color textDarkSecondary = Color(0xFF9AA59E);

  // ── Status Colors ────────────────────────────────────────────────────────────
  static const Color statusPending = Color(0xFFE67E22);
  static const Color statusConfirmed = Color(0xFF2980B9);
  static const Color statusPacked = Color(0xFF8E44AD);
  static const Color statusShipped = Color(0xFF16A085);
  static const Color statusDelivered = Color(0xFF27AE60);
  static const Color statusCancelled = Color(0xFFC0392B);
  static const Color statusReturned = Color(0xFF7F8C8D);

  // ── Luxury Botanical Accents ────────────────────────────────────────────────
  static const Color emeraldDeep = Color(0xFF0B2518);
  static const Color terracotta = Color(0xFFB5835A); // Soft Terracotta (#B5835A) for prices/badges
  static const Color terracottaLight = Color(0xFFF7F0E8);
  static const Color goldAccent = Color(0xFFC9A227); // Muted refined gold for verified/premium
  static const Color goldLight = Color(0xFFFCF7E8);
  static const Color mintDew = Color(0xFFE8F5E9);
  static const Color bKashPink = Color(0xFFE2136E);
  static const Color nagadOrange = Color(0xFFF7941D);
  static const Color rocketPurple = Color(0xFF8C3494);

  // ── Sobujayon Botanical Tokens (stitch_sobujayon_plant_marketplace_app) ─
  static const Color sobujayonPrimary = Color(0xFF012D1D);
  static const Color sobujayonPrimaryContainer = Color(0xFF1B4332);
  static const Color sobujayonOnPrimaryContainer = Color(0xFF86AF99);
  static const Color sobujayonSecondary = Color(0xFF2C694E);
  static const Color sobujayonSecondaryContainer = Color(0xFFAEEECB);
  static const Color sobujayonSecondaryFixed = Color(0xFFB1F0CE);
  static const Color sobujayonOnSecondaryContainer = Color(0xFF316E52);
  static const Color sobujayonTertiary = Color(0xFF3E1E00);
  static const Color sobujayonTertiaryContainer = Color(0xFF583311);
  static const Color sobujayonOnTertiaryContainer = Color(0xFFD09B70);
  static const Color sobujayonTertiaryFixed = Color(0xFFFFDCC2);
  static const Color sobujayonTertiaryFixedDim = Color(0xFFF4BB8E);
  static const Color sobujayonSurface = Color(0xFFF8FAF9);
  static const Color sobujayonSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color sobujayonSurfaceContainerLow = Color(0xFFF2F4F3);
  static const Color sobujayonSurfaceContainer = Color(0xFFECEEED);
  static const Color sobujayonSurfaceContainerHigh = Color(0xFFE6E9E8);
  static const Color sobujayonSurfaceContainerHighest = Color(0xFFE1E3E2);
  static const Color sobujayonOutline = Color(0xFF717973);
  static const Color sobujayonOutlineVariant = Color(0xFFC1C8C2);
  static const Color sobujayonInverseSurface = Color(0xFF2E3131);
  static const Color sobujayonInverseOnSurface = Color(0xFFEFF1F0);

  // ── Gradients ───────────────────────────────────────────────────────────────
  static const LinearGradient luxuryEmeraldGradient = LinearGradient(
    colors: [Color(0xFF012D1D), Color(0xFF1B4332), Color(0xFF2C694E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mintGlassGradient = LinearGradient(
    colors: [Color(0x331E6B47), Color(0x111E6B47)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
