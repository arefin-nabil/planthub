abstract class AppConstants {
  // App Info
  static const String appName = 'PlantHub';
  static const String appTagline = 'বাংলাদেশের সেরা নার্সারি মার্কেটপ্লেস';
  static const String currency = '৳';
  static const String currencyCode = 'BDT';

  // Padding / Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusCircle = 999.0;

  // Card / Image Dimensions
  static const double productCardWidth = 160.0;
  static const double productCardImageHeight = 140.0;
  static const double productCardHeight = 230.0;
  static const double nurseryCardHeight = 120.0;
  static const double bannerHeight = 180.0;
  static const double avatarSize = 48.0;
  static const double avatarSizeLg = 80.0;

  // Bottom Nav
  static const double bottomNavHeight = 64.0;
  static const double pageHorizontalPadding = 16.0;

  // Shimmer / Animation
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animMedium = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 600);
  static const Duration splashDuration = Duration(milliseconds: 2200);

  // Plant Categories (Bangla)
  static const List<String> plantCategories = [
    'সব',
    'ইনডোর',
    'আউটডোর',
    'সাকুলেন্ট',
    'ফুল গাছ',
    'ফলের গাছ',
    'ভেষজ',
    'ক্যাকটাস',
    'বনসাই',
    'অর্কিড',
  ];

  // Order Status Steps
  static const List<String> orderStatusSteps = [
    'পেন্ডিং',
    'কনফার্মড',
    'প্যাকড',
    'শিপড',
    'ডেলিভারড',
  ];

  // Verification Levels
  static const List<String> verificationLevels = [
    'Unverified',
    'Verified',
    'Premium Verified',
  ];

  // Consultation Types
  static const List<String> consultationTypes = [
    'চ্যাট',
    'ইমেজ রিভিউ',
  ];
}
