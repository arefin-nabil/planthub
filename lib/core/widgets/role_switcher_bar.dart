import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../../app/routes.dart';

class RoleSwitcherPill extends StatelessWidget {
  const RoleSwitcherPill({super.key});

  void _showRoleSwitcher(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _RoleSelectionSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final role = auth.activeRole;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showRoleSwitcher(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isDark ? role.color.withOpacity(0.2) : role.color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: role.color.withOpacity(0.4), width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(role.icon, size: 14, color: role.color),
            const SizedBox(width: 5),
            Text(
              role.titleBn,
              style: TextStyle(
                color: role.color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 3),
            Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: role.color),
          ],
        ),
      ),
    );
  }
}

class _RoleSelectionSheet extends StatelessWidget {
  const _RoleSelectionSheet();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final currentRole = auth.activeRole;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.swap_horiz_rounded, color: AppColors.primaryGreen, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ইউজার রোল পরিবর্তন', style: AppTextStyles.h2(context).copyWith(fontSize: 18)),
                    Text('এক ক্লিকেই অন্য রোলের ড্যাশবোর্ডে প্রবেশ করুন', style: AppTextStyles.bodySmall(context)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Role Option Cards
          ...UserRole.values.map((role) {
            final isSelected = currentRole == role;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? role.color.withOpacity(0.08)
                    : (isDark ? AppColors.darkSurface : AppColors.softWhite),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? role.color : AppColors.lightBorder.withOpacity(0.5),
                  width: isSelected ? 1.5 : 0.8,
                ),
              ),
              child: ListTile(
                leading: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: role.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(role.icon, color: role.color, size: 22),
                ),
                title: Row(
                  children: [
                    Text(
                      role.titleBn,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: isSelected ? role.color : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${role.titleEn})',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.naturalGray.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                subtitle: Text(
                  _getRoleSubtitle(role),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle_rounded, color: role.color, size: 22)
                    : const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.naturalGray),
                onTap: () {
                  auth.switchRole(role);
                  Navigator.pop(context);
                  _navigateForRole(context, role);
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  String _getRoleSubtitle(UserRole role) {
    switch (role) {
      case UserRole.customer:
        return 'গাছ কিনুন, পছন্দের তালিকা বানান এবং ডাক্তার পরামর্শ নিন';
      case UserRole.nurseryOwner:
        return 'স্টক আপডেট, লাইভ অর্ডার প্রসেস এবং সেলস রিপোর্ট';
      case UserRole.expert:
        return 'প্ল্যান্ট প্রেসক্রিপশন ও অ্যাপয়েন্টমেন্ট শিডিউল';
      case UserRole.admin:
        return 'প্ল্যাটফর্ম মনিটরিং ও নার্সারি ভেরিফিকেশন';
    }
  }

  void _navigateForRole(BuildContext context, UserRole role) {
    if (role == UserRole.nurseryOwner) {
      Navigator.pushNamed(context, AppRoutes.nurseryDashboard);
    } else if (role == UserRole.expert) {
      Navigator.pushNamed(context, AppRoutes.expertList);
    } else if (role == UserRole.customer) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (route) => false);
    }
  }
}
