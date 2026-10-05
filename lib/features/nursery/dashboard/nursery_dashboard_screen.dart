import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/mock/mock_data.dart';
import '../../../app/routes.dart';
import '../../../core/widgets/role_switcher_bar.dart';
import 'product_management_screen.dart';
import 'inventory_screen.dart';
import 'analytics_screen.dart';
import '../../orders/order_list_screen.dart';

class NurseryDashboardScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final ThemeMode themeMode;
  const NurseryDashboardScreen({super.key, this.onThemeToggle, required this.themeMode});

  @override
  State<NurseryDashboardScreen> createState() => _NurseryDashboardScreenState();
}

class _NurseryDashboardScreenState extends State<NurseryDashboardScreen> {
  int _selectedNavIndex = 0;

  final List<_NavItem> _navItems = const [
    _NavItem(Icons.dashboard_rounded, 'ড্যাশবোর্ড'),
    _NavItem(Icons.eco_rounded, 'প্রোডাক্ট'),
    _NavItem(Icons.inventory_2_outlined, 'ইনভেন্টরি'),
    _NavItem(Icons.receipt_long_outlined, 'অর্ডার'),
    _NavItem(Icons.bar_chart_rounded, 'অ্যানালিটিক্স'),
  ];

  @override
  Widget build(BuildContext context) {
    final stats = MockData.nurseryDashboardStats;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    // Large screens use rail, small use bottom nav
    final useSideRail = width >= 768;

    final pages = [
      _DashboardHome(stats: stats, isDark: isDark),
      const ProductManagementScreen(),
      const InventoryScreen(),
      const OrderListScreen(),
      const AnalyticsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco_rounded, color: AppColors.primaryGreen, size: 18),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Green Valley Nursery', style: AppTextStyles.h3(context).copyWith(fontSize: 14)),
                Text('ড্যাশবোর্ড', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 10)),
              ],
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: RoleSwitcherPill(),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: widget.onThemeToggle,
            color: AppColors.naturalGray,
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
                color: AppColors.naturalGray,
              ),
              Positioned(
                top: 10, right: 10,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: useSideRail
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedNavIndex,
                  onDestinationSelected: (i) => setState(() => _selectedNavIndex = i),
                  labelType: NavigationRailLabelType.all,
                  destinations: _navItems.map((n) => NavigationRailDestination(
                    icon: Icon(n.icon),
                    label: Text(n.label, style: const TextStyle(fontSize: 11)),
                  )).toList(),
                  selectedIconTheme: const IconThemeData(color: AppColors.primaryGreen),
                  selectedLabelTextStyle: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.w600, fontSize: 11),
                  backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
                  indicatorColor: AppColors.primaryGreen.withOpacity(0.15),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: pages[_selectedNavIndex]),
              ],
            )
          : pages[_selectedNavIndex],
      bottomNavigationBar: useSideRail
          ? null
          : BottomNavigationBar(
              currentIndex: _selectedNavIndex,
              onTap: (i) => setState(() => _selectedNavIndex = i),
              items: _navItems
                  .map((n) => BottomNavigationBarItem(icon: Icon(n.icon), label: n.label))
                  .toList(),
            ),
      floatingActionButton: _selectedNavIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.nurseryProducts),
              icon: const Icon(Icons.add_rounded),
              label: const Text('গাছ যোগ করুন'),
            )
          : null,
    );
  }
}

class _DashboardHome extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isDark;
  const _DashboardHome({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final weekly = (stats['weeklyOrders'] as List).cast<int>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('আজকের সারসংক্ষেপ', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 12),
          // Summary cards
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _SummaryCard(
                title: 'আজকের বিক্রি',
                value: '৳${(stats['todaySales'] as double).toInt()}',
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
              ),
              _SummaryCard(
                title: 'পেন্ডিং অর্ডার',
                value: '${stats['pendingOrders']}টি',
                icon: Icons.hourglass_empty_rounded,
                color: AppColors.statusPending,
              ),
              _SummaryCard(
                title: 'কম স্টক',
                value: '${stats['lowStockCount']}টি গাছ',
                icon: Icons.warning_amber_rounded,
                color: AppColors.warning,
              ),
              _SummaryCard(
                title: 'মোট কাস্টমার',
                value: '${stats['totalCustomers']}',
                icon: Icons.people_rounded,
                color: AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Weekly orders chart
          Text('সাপ্তাহিক অর্ডার', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 12),
          Container(
            height: 160,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: BarChart(
              BarChartData(
                barGroups: List.generate(weekly.length, (i) => BarChartGroupData(
                  x: i,
                  barRods: [BarChartRodData(
                    toY: weekly[i].toDouble(),
                    color: AppColors.primaryGreen,
                    width: 16,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                  )],
                )),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const days = ['সো', 'মং', 'বু', 'বৃ', 'শু', 'শ', 'র'];
                        return Text(days[v.toInt()], style: const TextStyle(fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Top products
          Text('সেরা বিক্রিত গাছ', style: AppTextStyles.sectionTitle(context)),
          const SizedBox(height: 12),
          ...(stats['topProducts'] as List).cast<Map<String, dynamic>>().map((p) => _TopProductRow(
            name: p['name'] as String,
            sold: p['sold'] as int,
            revenue: p['revenue'] as double,
          )),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: color),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: AppTextStyles.h2(context).copyWith(color: color)),
              Text(title, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopProductRow extends StatelessWidget {
  final String name;
  final int sold;
  final double revenue;
  const _TopProductRow({required this.name, required this.sold, required this.revenue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.eco_rounded, size: 20, color: AppColors.primaryGreen),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(name, style: AppTextStyles.h3(context).copyWith(fontSize: 14))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('৳${revenue.toInt()}', style: AppTextStyles.price(context).copyWith(fontSize: 14)),
              Text('$sold বিক্রি', style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}
