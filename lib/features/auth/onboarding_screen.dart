import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../app/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = const [
    _OnboardingData(
      gradient: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
      icon: Icons.storefront_rounded,
      titleBn: 'বিশ্বস্ত নার্সারি\nমার্কেটপ্লেস',
      title: 'Trusted Nursery Marketplace',
      descBn: 'শত শত ভেরিফাইড নার্সারি থেকে আপনার পছন্দের গাছটি খুঁজে নিন। ঘরে বসেই অর্ডার করুন।',
    ),
    _OnboardingData(
      gradient: [Color(0xFF0D47A1), Color(0xFF1565C0), Color(0xFF1976D2)],
      icon: Icons.medical_services_rounded,
      titleBn: 'বিশেষজ্ঞ পরামর্শ',
      title: 'Expert Consultation',
      descBn: 'আপনার গাছের যেকোনো সমস্যায় অভিজ্ঞ এক্সপার্টদের সাথে চ্যাট করুন বা ছবি দেখিয়ে পরামর্শ নিন।',
    ),
    _OnboardingData(
      gradient: [Color(0xFF4A148C), Color(0xFF6A1B9A), Color(0xFF7B1FA2)],
      icon: Icons.menu_book_rounded,
      titleBn: 'নলেজ হাব',
      title: 'Knowledge Hub',
      descBn: 'গাছের যত্ন, রোগ প্রতিরোধ, মৌসুমী টিপস — সব কিছু একটাই জায়গায়। শিখুন, বাড়ান, উপভোগ করুন।',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: AppConstants.animMedium,
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) => _OnboardingPage(data: _pages[index], size: size),
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: _pages.length,
                    effect: const WormEffect(
                      dotColor: Colors.white38,
                      activeDotColor: Colors.white,
                      dotHeight: 8,
                      dotWidth: 8,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      if (_currentPage < _pages.length - 1)
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                            child: const Text(
                              'এড়িয়ে যান',
                              style: TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                          ),
                        ),
                      Expanded(
                        flex: _currentPage < _pages.length - 1 ? 2 : 1,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.forestGreen,
                            minimumSize: const Size(0, 52),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _currentPage < _pages.length - 1 ? 'পরবর্তী' : 'শুরু করুন',
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                _currentPage < _pages.length - 1
                                    ? Icons.arrow_forward_rounded
                                    : Icons.eco_rounded,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final Size size;

  const _OnboardingPage({required this.data, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              // Icon container
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                ),
                child: Icon(data.icon, size: 52, color: Colors.white),
              ),
              const SizedBox(height: 36),
              Text(
                data.titleBn,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                data.descBn,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.7,
                ),
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final List<Color> gradient;
  final IconData icon;
  final String titleBn;
  final String title;
  final String descBn;

  const _OnboardingData({
    required this.gradient,
    required this.icon,
    required this.titleBn,
    required this.title,
    required this.descBn,
  });
}
