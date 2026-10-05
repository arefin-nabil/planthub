import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/providers.dart';
import '../features/auth/pages/splash_page.dart';
import '../features/auth/pages/onboarding_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/register_page.dart';
import '../features/marketplace/pages/home_page.dart';
import '../features/marketplace/pages/explore_page.dart';
import '../features/marketplace/pages/product_detail_page.dart';
import '../features/marketplace/pages/wishlist_page.dart';
import '../features/cart/pages/cart_page.dart';
import '../features/orders/pages/order_list_page.dart';
import '../features/orders/pages/order_detail_page.dart';
import '../features/nursery/pages/nursery_profile_page.dart';
import '../features/nursery/pages/nursery_dashboard_page.dart';
import '../features/nursery/pages/product_management_page.dart';
import '../features/nursery/pages/inventory_page.dart';
import '../features/nursery/pages/analytics_page.dart';
import '../features/consultation/pages/expert_list_page.dart';
import '../features/consultation/pages/expert_profile_page.dart';
import '../features/consultation/pages/book_consultation_page.dart';
import '../features/knowledge_hub/pages/knowledge_hub_page.dart';
import '../features/knowledge_hub/pages/article_detail_page.dart';
import '../features/notifications/pages/notifications_page.dart';
import '../features/profile/pages/profile_page.dart';
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
              AppRoutes.splash: (_) => SplashPage(onThemeToggle: themeProvider.toggleTheme),
              AppRoutes.onboarding: (_) => const OnboardingPage(),
              AppRoutes.login: (_) => const LoginPage(),
              AppRoutes.register: (_) => const RegisterPage(),
              AppRoutes.home: (_) => HomePage(
                    onThemeToggle: themeProvider.toggleTheme,
                    themeMode: themeProvider.themeMode,
                  ),
              AppRoutes.explore: (_) => const ExplorePage(),
              AppRoutes.productDetail: (_) => const ProductDetailPage(),
              AppRoutes.wishlist: (_) => const WishlistPage(),
              AppRoutes.cart: (_) => const CartPage(),
              AppRoutes.orderList: (_) => const OrderListPage(),
              AppRoutes.orderDetail: (_) => const OrderDetailPage(),
              AppRoutes.nurseryProfile: (_) => const NurseryProfilePage(),
              AppRoutes.nurseryDashboard: (_) => NurseryDashboardPage(
                    onThemeToggle: themeProvider.toggleTheme,
                    themeMode: themeProvider.themeMode,
                  ),
              AppRoutes.nurseryProducts: (_) => const ProductManagementPage(),
              AppRoutes.nurseryInventory: (_) => const InventoryPage(),
              AppRoutes.nurseryAnalytics: (_) => const AnalyticsPage(),
              AppRoutes.expertList: (_) => const ExpertListPage(),
              AppRoutes.expertProfile: (_) => const ExpertProfilePage(),
              AppRoutes.bookConsultation: (_) => const BookConsultationPage(),
              AppRoutes.knowledgeHub: (_) => const KnowledgeHubPage(),
              AppRoutes.articleDetail: (_) => const ArticleDetailPage(),
              AppRoutes.notifications: (_) => const NotificationsPage(),
              AppRoutes.profile: (_) => const ProfilePage(),
            },
          );
        },
      ),
    );
  }
}

