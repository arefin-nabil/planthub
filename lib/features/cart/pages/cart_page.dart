import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../provider/cart_provider.dart';
import '../../orders/provider/order_provider.dart';
import '../../auth/provider/auth_provider.dart';

import '../../../core/widgets/app_top_bar.dart';
import '../../../app/routes.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartPage> {
  String _paymentMethod = 'bkash';
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _giftMessageController = TextEditingController();
  bool _isGift = false;

  String _selectedDivision = 'ঢাকা';
  String _selectedDistrict = 'ঢাকা';
  String _selectedArea = 'ধানমন্ডি';

  static const Map<String, List<String>> _divisions = {
    'ঢাকা': ['ঢাকা', 'গাজীপুর', 'নারায়ণগঞ্জ', 'টাঙ্গাইল', 'মানিকগঞ্জ'],
    'চট্টগ্রাম': ['চট্টগ্রাম', 'কক্সবাজার', 'কুমিল্লা', 'ফেনী'],
    'রাজশাহী': ['রাজশাহী', 'বগুড়া', 'পাবনা', 'সিরাজগঞ্জ'],
    'সিলেট': ['সিলেট', 'মৌলভীবাজার', 'হবিগঞ্জ'],
    'খুলনা': ['খুলনা', 'যশোর', 'কুষ্টিয়া'],
    'বরিশাল': ['বরিশাল', 'পটুয়াখালী', 'ভোলা'],
    'রংপুর': ['রংপুর', 'দিনাজপুর'],
    'ময়মনসিংহ': ['ময়মনসিংহ', 'জামালপুর'],
  };

  static const Map<String, List<String>> _areas = {
    'ঢাকা': ['ধানমন্ডি', 'গুলশান', 'বনানী', 'উত্তরা', 'মিরপুর', 'মোহাম্মদপুর', 'মতিঝিল', 'বসুন্ধরা'],
    'গাজীপুর': ['টঙ্গী', 'জয়দেবপুর', 'কালিয়াকৈর', 'শ্রীপুর'],
    'নারায়ণগঞ্জ': ['সিদ্ধিরগঞ্জ', 'ফতুল্লা', 'রূপগঞ্জ', 'আড়াইহাজার'],
    'টাঙ্গাইল': ['সদর', 'মির্জাপুর', 'কালিহাতী'],
    'মানিকগঞ্জ': ['সদর', 'সিংগাইর', 'ঘিওর'],
    'চট্টগ্রাম': ['জিইসি', 'আগ্রাবাদ', 'নাসিরাবাদ', 'হালিশহর', 'পাঁচলাইশ', 'খুলশী'],
    'কক্সবাজার': ['সদর', 'উখিয়া', 'টেকনাফ'],
    'কুমিল্লা': ['কান্দিরপাড়', 'শাসনগাছা', 'টমছম ব্রিজ'],
    'ফেনী': ['সদর', 'দাগনভূঞা', 'পরশুরাম'],
    'রাজশাহী': ['বোয়ালিয়া', 'মতিহার', 'রাজপাড়া', 'শাহ মখদুম'],
    'বগুড়া': ['সদর', 'শেরপুর', 'শিবগঞ্জ'],
    'পাবনা': ['সদর', 'ঈশ্বরদী'],
    'সিরাজগঞ্জ': ['সদর', 'বেলকুচি'],
    'সিলেট': ['জিন্দাবাজার', 'উপশহর', 'আম্বরখানা', 'টিলাগড়'],
    'মৌলভীবাজার': ['সদর', 'শ্রীমঙ্গল'],
    'হবিগঞ্জ': ['সদর', 'মাধবপুর'],
    'খুলনা': ['খালিশপুর', 'দৌলতপুর', 'সোনাডাঙ্গা', 'খান জাহান আলী'],
    'যশোর': ['সদর', 'নওয়াপাড়া'],
    'কুষ্টিয়া': ['সদর', 'ভেড়ামারা'],
    'বরিশাল': ['সদর', 'রূপাতলী', 'নথুল্লাবাদ'],
    'পটুয়াখালী': ['সদর', 'কুয়াকাটা'],
    'ভোলা': ['সদর', 'চরফ্যাশন'],
    'রংপুর': ['সদর', 'মডার্ন মোড়'],
    'দিনাজপুর': ['সদর', 'ফুলবাড়ী'],
    'ময়মনসিংহ': ['গাঙ্গিনার পাড়', 'চরপাড়া', 'নতুন বাজার'],
    'জামালপুর': ['সদর', 'মেলান্দহ'],
  };

  Widget _buildAddressDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final validValue = items.contains(value) ? value : (items.isNotEmpty ? items.first : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.naturalGray)),
        const SizedBox(height: 4),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.softWhite,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: validValue,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDarkPrimary : AppColors.textPrimary,
              ),
              dropdownColor: isDark ? AppColors.darkCard : Colors.white,
              items: items.map((it) => DropdownMenuItem(value: it, child: Text(it, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(BuildContext context, bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ধাপ ২ / ৩',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: AppColors.sobujayonSecondary,
              ),
            ),
            Row(
              children: const [
                Icon(Icons.verified_user_rounded, size: 14, color: AppColors.sobujayonSecondary),
                SizedBox(width: 4),
                Text(
                  'নিরাপদ চেকআউট',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.sobujayonSecondary),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.sobujayonSecondary,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.sobujayonPrimary,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Container(
                height: 5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.sobujayonSurfaceContainerHigh,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('১. কার্ট', style: TextStyle(fontSize: 11, color: AppColors.sobujayonSecondary, fontWeight: FontWeight.w600)),
            Text(
              '২. ঠিকানা ও তথ্য',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Text('৩. পরিশোধ', style: TextStyle(fontSize: 11, color: AppColors.naturalGray)),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _couponController.dispose();
    _giftMessageController.dispose();
    super.dispose();
  }

  void _applyCoupon(CartProvider cart) {
    if (_couponController.text.trim().isEmpty) return;
    final success = cart.applyCoupon(_couponController.text.trim());
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 ২০% ডিসকাউন্ট কুপন সফলভাবে প্রয়োগ হয়েছে!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cart.couponError ?? 'ভুল কুপন কোড!'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();
    final items = cart.itemList;

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'শপিং ব্যাগ',
        subtitle: items.isNotEmpty ? '${cart.totalItemCount}টি গাছ কার্টে আছে' : null,
        showBackButton: Navigator.canPop(context),
        actions: [
          if (items.isNotEmpty)
            AppBarActionButton(
              icon: Icons.delete_outline_rounded,
              tooltip: 'কার্ট খালি করুন',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('কার্ট খালি করবেন?'),
                    content: const Text('আপনি কি নিশ্চিত যে সব গাছ কার্ট থেকে মুছে ফেলতে চান?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('না')),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        onPressed: () {
                          cart.clearCart();
                          Navigator.pop(ctx);
                        },
                        child: const Text('হ্যাঁ, মুছুন', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.shopping_bag_outlined, size: 72, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(height: 20),
                    Text('আপনার কার্ট খালি', style: AppTextStyles.h2(context)),
                    const SizedBox(height: 8),
                    Text(
                      'আপনার পছন্দের সবুজে বাড়ি সাজাতে এখনই পছন্দের গাছ নির্বাচন করুন',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium(context).copyWith(color: AppColors.naturalGray),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.explore),
                      icon: const Icon(Icons.eco_rounded),
                      label: const Text('গাছের কালেকশন দেখুন', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    children: [
                      // Stitch 3-Step Progress Indicator
                      _buildStepIndicator(context, isDark),
                      const SizedBox(height: 16),

                      // Free Delivery Progress Banner
                      if (cart.deliveryZone == DeliveryZone.insideDhaka)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cart.subtotal >= 2000
                                ? AppColors.success.withValues(alpha: 0.12)
                                : AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cart.subtotal >= 2000
                                  ? AppColors.success.withValues(alpha: 0.3)
                                  : AppColors.sobujayonSecondary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                cart.subtotal >= 2000 ? Icons.check_circle_rounded : Icons.local_shipping_rounded,
                                color: cart.subtotal >= 2000 ? AppColors.success : AppColors.sobujayonSecondary,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  cart.subtotal >= 2000
                                      ? '🎉 অভিনন্দন! আপনি ফ্রি ডেলিভারি উপভোগ করছেন।'
                                      : 'আর ৳${(2000 - cart.subtotal).clamp(0, 2000).toInt()} টাকার অর্ডার করলেই ফ্রি ডেলিভারি!',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: cart.subtotal >= 2000 ? AppColors.success : AppColors.sobujayonSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Stitch Delivery Address Section (rounded-[26px])
                      _StitchCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 38,
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.local_shipping_rounded, color: AppColors.sobujayonPrimary, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'ডেলিভারি ঠিকানা',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                          ),
                                        ),
                                        Text(
                                          'সুরক্ষিত প্যাকেজে আপনার দ্বারে পৌঁছাবে',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: isDark ? AppColors.textDarkSecondary : const Color(0xFF607268),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLow,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: const Text(
                                    'হোম ডেলিভারি',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.sobujayonSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // Cascading Dropdowns
                            Row(
                              children: [
                                // Division Dropdown
                                Expanded(
                                  child: _buildAddressDropdown(
                                    label: 'বিভাগ (Division)',
                                    value: _selectedDivision,
                                    items: _divisions.keys.toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _selectedDivision = val;
                                          final districts = _divisions[val] ?? ['ঢাকা'];
                                          _selectedDistrict = districts.first;
                                          final areas = _areas[_selectedDistrict] ?? ['সদর'];
                                          _selectedArea = areas.first;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // District Dropdown
                                Expanded(
                                  child: _buildAddressDropdown(
                                    label: 'জেলা (District)',
                                    value: _selectedDistrict,
                                    items: _divisions[_selectedDivision] ?? [_selectedDistrict],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _selectedDistrict = val;
                                          final areas = _areas[val] ?? ['সদর'];
                                          _selectedArea = areas.first;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            // Area Dropdown
                            _buildAddressDropdown(
                              label: 'এলাকা (Area)',
                              value: _selectedArea,
                              items: _areas[_selectedDistrict] ?? [_selectedArea],
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedArea = val);
                              },
                            ),
                            const SizedBox(height: 10),
                            // Specific House/Flat Address
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'সুনির্দিষ্ট ঠিকানা (House / Flat)',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF607268)),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLow,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: isDark ? AppColors.darkBorder : const Color(0xFFE8EFEA)),
                                  ),
                                  child: TextField(
                                    controller: TextEditingController(text: 'বাড়ি নং ১৪/বি, ফ্ল্যাট ৪এ, রোড ৭১'),
                                    style: TextStyle(fontSize: 12, color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'বাসা/হোল্ডিং, ফ্ল্যাট নম্বর...',
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Stitch Luxury Gift Option Section
                      _StitchCard(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: AppColors.sobujayonTertiaryFixed.withValues(alpha: 0.6),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.card_giftcard_rounded, color: AppColors.sobujayonTertiary, size: 20),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'এটি কি কারো জন্য উপহার?',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'হাতে লেখা শুভেচ্ছা কার্ড ও প্রিমিয়াম মোড়ক',
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            color: isDark ? AppColors.textDarkSecondary : const Color(0xFF607268),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Switch.adaptive(
                                  value: _isGift,
                                  activeColor: AppColors.sobujayonSecondary,
                                  onChanged: (val) => setState(() => _isGift = val),
                                ),
                              ],
                            ),
                            AnimatedCrossFade(
                              duration: const Duration(milliseconds: 250),
                              crossFadeState: _isGift ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                              firstChild: const SizedBox.shrink(),
                              secondChild: Container(
                                margin: const EdgeInsets.only(top: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.sobujayonTertiaryFixed.withValues(alpha: 0.22),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.sobujayonOnTertiaryContainer.withValues(alpha: 0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(9999),
                                          ),
                                          child: Row(
                                            children: const [
                                              Icon(Icons.spa_rounded, size: 12, color: AppColors.sobujayonTertiary),
                                              SizedBox(width: 4),
                                              Text(
                                                'বোটানিক্যাল হ্যান্ডমেড কার্ড',
                                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.sobujayonTertiary),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          'বিনামূল্যে অন্তর্ভুক্ত',
                                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: AppColors.sobujayonOnTertiaryContainer),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      'হাতে লেখা ব্যক্তিগত বার্তা',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.sobujayonPrimary),
                                    ),
                                    const SizedBox(height: 4),
                                    TextField(
                                      controller: _giftMessageController,
                                      maxLines: 2,
                                      decoration: InputDecoration(
                                        hintText: 'আপনার প্রিয়জনের জন্য উষ্ণ কোনো বার্তা লিখুন (যেমন: প্রিয় নাবিলা, নতুন ঘরের জন্য এক টুকরো সবুজ ভালোবাসা! 🌱)',
                                        hintStyle: const TextStyle(fontSize: 11, color: AppColors.naturalGray),
                                        filled: true,
                                        fillColor: isDark ? AppColors.darkCard : Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(color: AppColors.sobujayonOnTertiaryContainer.withValues(alpha: 0.4)),
                                        ),
                                        contentPadding: const EdgeInsets.all(10),
                                      ),
                                      style: const TextStyle(fontSize: 11.5),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: const [
                                        Icon(Icons.eco_rounded, size: 14, color: AppColors.sobujayonOnTertiaryContainer),
                                        SizedBox(width: 6),
                                        Text(
                                          'প্রাকৃতিক পাটের ফিতা ও ক্রাফট পেপারে মোড়ানো হবে',
                                          style: TextStyle(fontSize: 10.5, color: AppColors.sobujayonOnTertiaryContainer),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Stitch Order Summary Card
                      _StitchCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'অর্ডারের সারসংক্ষেপ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLow,
                                    borderRadius: BorderRadius.circular(9999),
                                  ),
                                  child: Text(
                                    '${cart.totalItemCount}টি চারা গাছ',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF607268)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Items Mini List
                            ...items.map((cartItem) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: cartItem.plant.imageUrl,
                                      width: 48,
                                      height: 48,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cartItem.plant.nameBn,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          'সিরামিক টব সহ • ${cartItem.quantity}টি',
                                          style: const TextStyle(fontSize: 10.5, color: Color(0xFF607268)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    '৳${(cartItem.plant.price * cartItem.quantity).toInt()}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                            const SizedBox(height: 6),

                            // Financial Breakdown Container
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLow,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  _PriceRow(label: 'সাবটোটাল (উপমোট)', value: '৳${cart.subtotal.toInt()}'),
                                  if (cart.discountAmount > 0)
                                    _PriceRow(
                                      label: 'ডিসকাউন্ট (${cart.couponCode})',
                                      value: '-৳${cart.discountAmount.toInt()}',
                                      isDiscount: true,
                                    ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: const [
                                          Text('ইকো-ফ্রেন্ডলি প্যাকেজিং', style: TextStyle(fontSize: 12, color: Color(0xFF607268))),
                                          SizedBox(width: 4),
                                          Icon(Icons.compost_rounded, size: 14, color: AppColors.sobujayonSecondary),
                                        ],
                                      ),
                                      const Text('৳৫০', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  _PriceRow(
                                    label: 'নিরাপদ উদ্ভিদ ডেলিভারি',
                                    value: cart.deliveryCharge == 0 ? 'ফ্রি' : '৳${cart.deliveryCharge.toInt()}',
                                  ),
                                  const Divider(height: 16),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'সর্বমোট',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                            ),
                                          ),
                                          const Text(
                                            '(ভ্যাট অন্তর্ভুক্ত)',
                                            style: TextStyle(fontSize: 10, color: Color(0xFF607268)),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '৳${(cart.grandTotal + 50).toInt()}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
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
                      const SizedBox(height: 14),

                      // Stitch Payment Method Section
                      _StitchCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'পরিশোধের মাধ্যম',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Icon(Icons.lock_outline_rounded, size: 13, color: AppColors.sobujayonSecondary),
                                    SizedBox(width: 4),
                                    Text(
                                      '১০০% নিরাপদ',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.sobujayonSecondary),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // bKash Tile
                            _StitchPaymentCard(
                              title: 'bKash (বিকাশ)',
                              subtitle: 'ইনস্ট্যান্ট পেমেন্ট গেটওয়ে',
                              badgeText: '৳৫০ ক্যাশব্যাক',
                              chipText: 'বিকাশ',
                              chipColor: AppColors.bKashPink,
                              icon: Icons.bolt_rounded,
                              isSelected: _paymentMethod == 'bkash',
                              onTap: () => setState(() => _paymentMethod = 'bkash'),
                            ),
                            // Nagad Tile
                            _StitchPaymentCard(
                              title: 'Nagad (নগদ)',
                              subtitle: 'ডাক বিভাগের ডিজিটাল লেনদেন',
                              chipText: 'নগদ',
                              chipColor: AppColors.nagadOrange,
                              icon: Icons.account_balance_wallet_rounded,
                              isSelected: _paymentMethod == 'nagad',
                              onTap: () => setState(() => _paymentMethod = 'nagad'),
                            ),
                            // Rocket Tile
                            _StitchPaymentCard(
                              title: 'Rocket (রকেট)',
                              subtitle: 'ডিবিবিএল মোবাইল ব্যাংকিং',
                              chipText: 'রকেট',
                              chipColor: AppColors.rocketPurple,
                              icon: Icons.rocket_launch_rounded,
                              isSelected: _paymentMethod == 'rocket',
                              onTap: () => setState(() => _paymentMethod = 'rocket'),
                            ),
                            // COD Tile
                            _StitchPaymentCard(
                              title: 'ক্যাশ অন ডেলিভারি (COD)',
                              subtitle: 'গাছ বুঝে নিয়ে মূল্য পরিশোধ করুন',
                              chipText: 'ক্যাশ',
                              chipColor: AppColors.sobujayonSecondary,
                              icon: Icons.doorbell_outlined,
                              isSelected: _paymentMethod == 'cod',
                              onTap: () => setState(() => _paymentMethod = 'cod'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Stitch Guarantee Micro-badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.eco_rounded, size: 15, color: AppColors.sobujayonSecondary),
                          SizedBox(width: 6),
                          Text(
                            'সবুজায়ন সেফটি গ্যারান্টি: ৭ দিনের সুস্থ উদ্ভিদের নিশ্চয়তা',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF607268),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 90),
                    ],
                  ),
                ),

                // Floating Checkout Bar (Stitch full-pill CTA container)
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                  decoration: BoxDecoration(
                    color: (isDark ? AppColors.darkSurface : Colors.white).withValues(alpha: 0.92),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF012D1D).withValues(alpha: 0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.sobujayonPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                      elevation: 4,
                      shadowColor: AppColors.sobujayonPrimary.withValues(alpha: 0.3),
                    ),
                    onPressed: () {
                      final order = context.read<OrderProvider>().placeOrder(
                        cartItems: cart.itemList,
                        totalAmount: cart.grandTotal + 50,
                        paymentMethod: _paymentMethod.toUpperCase(),
                        address: '$_selectedArea, $_selectedDistrict, $_selectedDivision',
                        phone: auth.user.phone,
                      );

                      if (order != null) {
                        cart.clearCart();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (ctx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppColors.sobujayonSecondaryContainer.withValues(alpha: 0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check_circle_rounded, color: AppColors.sobujayonSecondary, size: 54),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'ধন্যবাদ! অর্ডার সম্পন্ন হয়েছে',
                                  style: AppTextStyles.h2(context).copyWith(
                                    color: AppColors.sobujayonPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'অর্ডার নং: ${order.id}\nআপনার পছন্দের গাছগুলো যত্নের সাথে প্যাকেজিং করে পাঠানো হবে।',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall(context).copyWith(color: const Color(0xFF607268)),
                                ),
                              ],
                            ),
                            actions: [
                              Center(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.sobujayonPrimary,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    Navigator.pushReplacementNamed(context, AppRoutes.orderList);
                                  },
                                  child: const Text('অর্ডার স্ট্যাটাস দেখুন', style: TextStyle(fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_rounded, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'অর্ডার নিশ্চিত করুন • ৳${(cart.grandTotal + 50).toInt()}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CartItemTile extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int> onQtyChanged;
  final VoidCallback onRemove;

  const _CartItemTile({
    required this.item,
    required this.onQtyChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: item.plant.imageUrl,
              width: 68,
              height: 68,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.plant.nameBn, style: AppTextStyles.h3(context).copyWith(fontSize: 14)),
                Text(item.plant.nurseryName, style: AppTextStyles.bodySmall(context).copyWith(fontSize: 11)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('৳${item.plant.price.toInt()}', style: AppTextStyles.price(context).copyWith(fontSize: 15)),
                    const Spacer(),
                    _QtyControl(
                      qty: item.quantity,
                      onDecrease: () { if (item.quantity > 1) onQtyChanged(item.quantity - 1); },
                      onIncrease: () => onQtyChanged(item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final int qty;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QtyControl({
    required this.qty,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightBorder),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.remove, size: 14),
            onPressed: onDecrease,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ),
          IconButton(
            icon: const Icon(Icons.add, size: 14),
            onPressed: onIncrease,
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String value;
  final String groupValue;
  final String label;
  final String subtitle;
  final IconData icon;
  final Color color;
  final ValueChanged<String?> onChanged;

  const _PaymentOption({
    required this.value,
    required this.groupValue,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : AppColors.lightBorder,
            width: isSelected ? 1.5 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isSelected ? color : null)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.naturalGray)),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: groupValue,
              activeColor: color,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final bool isDiscount;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold
                ? AppTextStyles.h3(context).copyWith(fontSize: 14)
                : AppTextStyles.bodyMedium(context).copyWith(fontSize: 13),
          ),
          Text(
            value,
            style: isBold
                ? AppTextStyles.price(context).copyWith(fontSize: 16)
                : AppTextStyles.bodyMedium(context).copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDiscount ? AppColors.success : null,
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.h3(context).copyWith(fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Stitch Botanical 26px rounded card with delicate specification shadows
class _StitchCard extends StatelessWidget {
  final Widget child;
  const _StitchCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.sobujayonSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE8EFEA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF012D1D).withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Stitch Payment Card with radio indicator and branded chip
class _StitchPaymentCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? badgeText;
  final String chipText;
  final Color chipColor;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _StitchPaymentCard({
    required this.title,
    required this.subtitle,
    this.badgeText,
    required this.chipText,
    required this.chipColor,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.sobujayonPrimary.withValues(alpha: isDark ? 0.15 : 0.04)
              : (isDark ? AppColors.darkSurface : AppColors.sobujayonSurfaceContainerLow),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.sobujayonPrimary : Colors.transparent,
            width: 1.8,
          ),
        ),
        child: Row(
          children: [
            // Circular radio indicator
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.sobujayonPrimary : (isDark ? AppColors.darkBorder : AppColors.sobujayonSurfaceContainerHighest),
                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            // Branded chip square
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  chipText,
                  style: TextStyle(
                    color: chipColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textDarkPrimary : AppColors.sobujayonPrimary,
                        ),
                      ),
                      if (badgeText != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: chipColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            badgeText!,
                            style: TextStyle(
                              color: chipColor,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: isDark ? AppColors.textDarkSecondary : const Color(0xFF607268),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppColors.sobujayonPrimary : const Color(0xFF607268),
            ),
          ],
        ),
      ),
    );
  }
}


/// Compatibility typedef
typedef CartScreen = CartPage;
