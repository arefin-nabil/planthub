import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../app/routes.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String _selectedRole = 'customer';

  final List<Map<String, dynamic>> _roles = [
    {'value': 'customer', 'label': 'কাস্টমার', 'icon': Icons.person_rounded, 'desc': 'গাছ কিনুন'},
    {'value': 'nursery', 'label': 'নার্সারি', 'icon': Icons.storefront_rounded, 'desc': 'গাছ বিক্রি করুন'},
    {'value': 'expert', 'label': 'এক্সপার্ট', 'icon': Icons.medical_services_rounded, 'desc': 'পরামর্শ দিন'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.softWhite,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
        ),
        title: const Text('নিবন্ধন করুন'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.pageHorizontalPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('আপনার রোল বেছে নিন', style: AppTextStyles.sectionTitle(context)),
              const SizedBox(height: 12),
              Row(
                children: _roles.map((role) {
                  final isSelected = _selectedRole == role['value'];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedRole = role['value'] as String),
                      child: AnimatedContainer(
                        duration: AppConstants.animFast,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primaryGreen.withOpacity(0.12)
                              : (isDark ? AppColors.darkCard : Colors.white),
                          borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                          border: Border.all(
                            color: isSelected ? AppColors.primaryGreen : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              role['icon'] as IconData,
                              color: isSelected ? AppColors.primaryGreen : AppColors.naturalGray,
                              size: 26,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              role['label'] as String,
                              style: AppTextStyles.label(context).copyWith(
                                color: isSelected ? AppColors.primaryGreen : AppColors.naturalGray,
                                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              role['desc'] as String,
                              style: AppTextStyles.bodySmall(context).copyWith(fontSize: 9),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              Text('ব্যক্তিগত তথ্য', style: AppTextStyles.sectionTitle(context)),
              const SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'পুরো নাম',
                  prefixIcon: Icon(Icons.badge_outlined, color: AppColors.primaryGreen),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'নাম দিন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'মোবাইল নম্বর',
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primaryGreen),
                  prefixText: '+880 ',
                ),
                validator: (v) => (v == null || v.length < 10) ? 'সঠিক নম্বর দিন' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'ইমেইল (ঐচ্ছিক)',
                  prefixIcon: Icon(Icons.email_outlined, color: AppColors.primaryGreen),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'পাসওয়ার্ড',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primaryGreen),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.naturalGray,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6) ? 'কমপক্ষে ৬ অক্ষর' : null,
              ),
              const SizedBox(height: 28),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_selectedRole == 'nursery') {
                      Navigator.pushReplacementNamed(context, AppRoutes.nurseryDashboard);
                    } else {
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    }
                  }
                },
                child: const Text('অ্যাকাউন্ট তৈরি করুন'),
              ),
              const SizedBox(height: 16),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ইতিমধ্যে অ্যাকাউন্ট আছে?', style: AppTextStyles.bodyMedium(context)),
                    TextButton(
                      onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                      child: Text(
                        'লগইন করুন',
                        style: AppTextStyles.bodyMedium(context).copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}


/// Compatibility typedef
typedef RegisterScreen = RegisterPage;
