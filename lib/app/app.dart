import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/providers.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/marketplace/home_screen.dart';
import '../features/marketplace/explore_screen.dart';
import '../features/marketplace/product_detail_screen.dart';
import '../features/marketplace/wishlist_screen.dart';
import '../features/marketplace/cart_screen.dart';
import '../features/orders/order_list_screen.dart';
import '../features/orders/order_detail_screen.dart';
import '../features/nursery/nursery_profile_screen.dart';
import '../features/nursery/dashboard/nursery_dashboard_screen.dart';
import '../features/nursery/dashboard/product_management_screen.dart';
import '../features/nursery/dashboard/inventory_screen.dart';
import '../features/nursery/dashboard/analytics_screen.dart';
import '../features/consultation/expert_list_screen.dart';
import '../features/consultation/expert_profile_screen.dart';
import '../features/consultation/book_consultation_screen.dart';
import '../features/knowledge_hub/knowledge_hub_screen.dart';
import '../features/knowledge_hub/article_detail_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/profile/profile_screen.dart';
import 'routes.dart';

class PlantHubApp extends StatelessWidget {
  const PlantHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => NurseryProvider()),
        ChangeNotifierProvider(create: (_) => ConsultationProvider()),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = context.watch<ThemeProvider>();
          final localeProvider = context.watch<LocaleProvider>();

          return MaterialApp(
            title: 'PlantHub Bangladesh',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.currentLocale,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (_) => SplashScreen(onThemeToggle: themeProvider.toggleTheme),
              AppRoutes.onboarding: (_) => const OnboardingScreen(),
              AppRoutes.login: (_) => const LoginScreen(),
              AppRoutes.register: (_) => const RegisterScreen(),
              AppRoutes.home: (_) => HomeScreen(
                    onThemeToggle: themeProvider.toggleTheme,
                    themeMode: themeProvider.themeMode,
                  ),
          AppRoutes.explore: (_) => const ExploreScreen(),
          AppRoutes.productDetail: (_) => const ProductDetailScreen(),
          AppRoutes.wishlist: (_) => const WishlistScreen(),
          AppRoutes.cart: (_) => const CartScreen(),
          AppRoutes.orderList: (_) => const OrderListScreen(),
          AppRoutes.orderDetail: (_) => const OrderDetailScreen(),
          AppRoutes.nurseryProfile: (_) => const NurseryProfileScreen(),
          AppRoutes.nurseryDashboard: (_) => NurseryDashboardScreen(
                onThemeToggle: themeProvider.toggleTheme,
                themeMode: themeProvider.themeMode,
              ),
          AppRoutes.nurseryProducts: (_) => const ProductManagementScreen(),
          AppRoutes.nurseryInventory: (_) => const InventoryScreen(),
          AppRoutes.nurseryAnalytics: (_) => const AnalyticsScreen(),
          AppRoutes.expertList: (_) => const ExpertListScreen(),
          AppRoutes.expertProfile: (_) => const ExpertProfileScreen(),
          AppRoutes.bookConsultation: (_) => const BookConsultationScreen(),
          AppRoutes.knowledgeHub: (_) => const KnowledgeHubScreen(),
          AppRoutes.articleDetail: (_) => const ArticleDetailScreen(),
          AppRoutes.notifications: (_) => const NotificationsScreen(),
          AppRoutes.profile: (_) => const ProfileScreen(),
        },
      );
    },
  ),
);
}
}
