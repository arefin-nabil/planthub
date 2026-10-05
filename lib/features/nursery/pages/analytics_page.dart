import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/mock/mock_data.dart';

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({super.key});
  @override
  State<AnalyticsPage> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsPage> {
  String _period = 'এই মাস';

  @override
  Widget build(BuildContext context) {
    final stats = MockData.nurseryDashboardStats;
    final monthlyRevenue = (stats['monthlyRevenueSeries'] as List).cast<double>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('অ্যানালিটিক্স'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _period,
            onSelected: (v) => setState(() => _period = v),
            itemBuilder: (_) => ['এই সপ্তাহ', 'এই মাস', 'এই বছর']
                .map((p) => PopupMenuItem(value: p, child: Text(p)))
                .toList(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Text(_period, style: AppTextStyles.label(context).copyWith(color: AppColors.primaryGreen)),
                  const Icon(Icons.arrow_drop_down_rounded, color: AppColors.primaryGreen),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkGreen, AppColors.primaryGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('মোট রাজস্ব', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 6),
                  Text(
                    '৳${(stats['monthlyRevenue'] as double).toInt()}',
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 4),
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('+24% গত মাসের তুলনায়', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Revenue line chart
            Text('মাসিক রাজস্ব ট্রেন্ড', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
                border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(monthlyRevenue.length, (i) => FlSpot(i.toDouble(), monthlyRevenue[i] / 1000)),
                      isCurved: true,
                      color: AppColors.primaryGreen,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: AppColors.primaryGreen.withOpacity(0.08),
                      ),
                    ),
                  ],
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 40,
                    getDrawingHorizontalLine: (v) => FlLine(
                      color: AppColors.lightBorder,
                      strokeWidth: 0.8,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          const months = ['মার্চ', 'এপ্রিল', 'মে', 'জুন', 'জুলাই', 'আগস্ট'];
                          return Text(months[v.toInt()], style: const TextStyle(fontSize: 9));
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
            const SizedBox(height: 20),

            // Key metrics
            Text('মূল পরিসংখ্যান', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _MetricCard(label: 'মোট অর্ডার', value: '${stats['pendingOrders']}', unit: 'টি', color: AppColors.info),
                _MetricCard(label: 'মোট কাস্টমার', value: '${stats['totalCustomers']}', unit: 'জন', color: AppColors.success),
                _MetricCard(label: 'মোট প্রোডাক্ট', value: '${stats['totalProducts']}', unit: 'টি', color: AppColors.primaryGreen),
                _MetricCard(label: 'গড় অর্ডার মূল্য', value: '৳2,450', unit: '', color: AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  const _MetricCard({required this.label, required this.value, required this.unit, required this.color});

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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$value$unit', style: AppTextStyles.h1(context).copyWith(color: color, fontSize: 22)),
          const SizedBox(height: 3),
          Text(label, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
        ],
      ),
    );
  }
}


/// Compatibility typedef
typedef AnalyticsScreen = AnalyticsPage;
