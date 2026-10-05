import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../app/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Top green header
          Container(
            height: size.height * 0.38,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.forestGreen, AppColors.primaryGreen],
              ),
            ),
          ),
          // Decorative leaf shapes
          Positioned(
            top: 40,
            right: -20,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo area
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.eco_rounded, color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'PlantHub',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'স্বাগতম!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'আপনার অ্যাকাউন্টে লগইন করুন',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Form Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.radiusXl),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Phone/Email field
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'ইমেইল বা ফোন',
                              prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.primaryGreen),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'প্রয়োজন' : null,
                          ),
                          const SizedBox(height: 16),
                          // Password field
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
                          const SizedBox(height: 8),
                          // Forgot password
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'পাসওয়ার্ড ভুলে গেছেন?',
                                style: AppTextStyles.label(context).copyWith(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Login button
                          ElevatedButton(
                            onPressed: _isLoading ? null : () {
                              if (_formKey.currentState!.validate()) {
                                setState(() => _isLoading = true);
                                Future.delayed(const Duration(seconds: 1), () {
                                  if (mounted) {
                                    setState(() => _isLoading = false);
                                    Navigator.pushReplacementNamed(context, AppRoutes.home);
                                  }
                                });
                              }
                            },
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : const Text('লগইন করুন'),
                          ),
                          const SizedBox(height: 20),
                          // Divider
                          Row(
                            children: [
                              const Expanded(child: Divider()),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text('অথবা', style: AppTextStyles.bodySmall(context)),
                              ),
                              const Expanded(child: Divider()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Demo role buttons
                          Text('Demo-তে দেখুন:', style: AppTextStyles.label(context)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              _RoleChip(
                                label: 'কাস্টমার',
                                icon: Icons.person_rounded,
                                onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.home),
                              ),
                              _RoleChip(
                                label: 'নার্সারি',
                                icon: Icons.storefront_rounded,
                                onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.nurseryDashboard),
                              ),
                              _RoleChip(
                                label: 'এক্সপার্ট',
                                icon: Icons.medical_services_rounded,
                                onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.expertList),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('অ্যাকাউন্ট নেই?', style: AppTextStyles.bodyMedium(context)),
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
                        child: Text(
                          'নিবন্ধন করুন',
                          style: AppTextStyles.bodyMedium(context).copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _RoleChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreen),
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primaryGreen.withOpacity(0.06),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primaryGreen),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
