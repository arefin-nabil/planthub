import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/app_top_bar.dart';
import '../../../data/mock/mock_data.dart';
import '../../../app/routes.dart';

class BookConsultationPage extends StatefulWidget {
  const BookConsultationPage({super.key});
  @override
  State<BookConsultationPage> createState() => _BookConsultationScreenState();
}

class _BookConsultationScreenState extends State<BookConsultationPage> {
  String _selectedType = 'চ্যাট';
  int _selectedSlot = -1;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  final List<String> _slots = ['৯:০০', '১০:৩০', '১২:০০', '২:৩০', '৪:০০', '৫:৩০'];
  final List<bool> _slotAvailable = [true, false, true, true, false, true];

  @override
  Widget build(BuildContext context) {
    final expert = (ModalRoute.of(context)?.settings.arguments as MockExpert?) ?? MockData.experts.first;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PlantHubAppBar(
        title: 'পরামর্শ বুক করুন',
        subtitle: expert.name,
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expert mini card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.darkGreen, AppColors.primaryGreen],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusLg),
              ),
              child: Row(
                children: [
                  const Icon(Icons.support_agent_rounded, color: Colors.white, size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(expert.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                        Text(expert.title, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                      ],
                    ),
                  ),
                  Text('৳${expert.pricePerSession}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Consultation Type
            Text('পরামর্শের ধরন', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            Row(
              children: AppConstants.consultationTypes.map((type) {
                final isSelected = _selectedType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: AppConstants.animFast,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryGreen.withOpacity(0.1) : (isDark ? AppColors.darkCard : Colors.white),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            type == 'চ্যাট' ? Icons.chat_bubble_outline_rounded : Icons.image_outlined,
                            color: isSelected ? AppColors.primaryGreen : AppColors.naturalGray,
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            type,
                            style: TextStyle(
                              color: isSelected ? AppColors.primaryGreen : AppColors.naturalGray,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Date Picker
            Text('তারিখ বেছে নিন', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 7,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final date = DateTime.now().add(Duration(days: i + 1));
                  final isSelected = date.day == _selectedDate.day;
                  const days = ['রবি', 'সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি'];
                  return GestureDetector(
                    onTap: () => setState(() => _selectedDate = date),
                    child: AnimatedContainer(
                      duration: AppConstants.animFast,
                      width: 56,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryGreen : (isDark ? AppColors.darkCard : Colors.white),
                        borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                        border: Border.all(color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            days[date.weekday % 7],
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.naturalGray,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Time Slots
            Text('সময় বেছে নিন', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.5,
              ),
              itemCount: _slots.length,
              itemBuilder: (context, i) {
                final isSelected = _selectedSlot == i;
                final isAvailable = _slotAvailable[i];
                return GestureDetector(
                  onTap: isAvailable ? () => setState(() => _selectedSlot = i) : null,
                  child: AnimatedContainer(
                    duration: AppConstants.animFast,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : isAvailable
                              ? (isDark ? AppColors.darkCard : Colors.white)
                              : AppColors.lightBorder.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(AppConstants.radiusMd),
                      border: Border.all(
                        color: isSelected ? AppColors.primaryGreen : AppColors.lightBorder,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _slots[i],
                        style: TextStyle(
                          color: isSelected ? Colors.white : isAvailable ? AppColors.textPrimary : AppColors.naturalGray,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          fontSize: 13,
                          decoration: !isAvailable ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Note
            Text('বার্তা (ঐচ্ছিক)', style: AppTextStyles.sectionTitle(context)),
            const SizedBox(height: 10),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'আপনার সমস্যা বা প্রশ্ন সংক্ষেপে লিখুন...',
              ),
            ),
            const SizedBox(height: 28),

            // Confirm button
            ElevatedButton(
              onPressed: _selectedSlot >= 0
                  ? () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('বুকিং সফল! ✅'),
                          content: Text(
                            '${expert.name}-এর সাথে $_selectedType পরামর্শ বুক হয়েছে।\n'
                            'তারিখ: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}\n'
                            'সময়: ${_slots[_selectedSlot]}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text('ঠিক আছে'),
                            ),
                          ],
                        ),
                      )
                  : null,
              child: const Text('বুকিং নিশ্চিত করুন'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}


/// Compatibility typedef
typedef BookConsultationScreen = BookConsultationPage;
