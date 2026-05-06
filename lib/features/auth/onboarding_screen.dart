import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tebaba_mobile/features/auth/login_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'حلل أداء مركزك الطبي',
      'desc': 'ذكاء اصطناعي متخصص يفحص الأرقام ويكشف الثغرات المالية والتشغيلية في دقائق.',
      'icon': '📊',
    },
    {
      'title': 'أدوات نمو ذكية',
      'desc': 'أكثر من 8 حاسبات تفاعلية لمساعدتك في اتخاذ قرارات التوسع والتوظيف والتسعير.',
      'icon': '🚀',
    },
    {
      'title': 'مستشارك الخاص 24/7',
      'desc': 'دردشة ذكية مع Tebaba Expert AI للإجابة على كل تساؤلاتك حول إدارة البزنس الطبي.',
      'icon': '🤖',
    },
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) => setState(() => _currentPage = page),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(page['icon']!, style: const TextStyle(fontSize: 100)).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                    const SizedBox(height: 50),
                    Text(
                      page['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ).animate().fadeIn(delay: 200.ms),
                    const SizedBox(height: 20),
                    Text(
                      page['desc']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16, color: Colors.white54, height: 1.5),
                    ).animate().fadeIn(delay: 400.ms),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? const Color(0xFF1DD9A0) : Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _currentPage == _pages.length - 1 
                    ? _finishOnboarding 
                    : () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1DD9A0),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text(_currentPage == _pages.length - 1 ? 'ابدأ الآن' : 'التالي', style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
