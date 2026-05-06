import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tebaba_mobile/features/auth/login_screen.dart';
import 'package:tebaba_mobile/features/auth/onboarding_screen.dart';
import 'package:tebaba_mobile/features/home/home_screen.dart';
import 'package:tebaba_mobile/features/main_shell.dart';
import 'package:tebaba_mobile/services/auth_service.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tebaba_mobile/core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash duration
    
    final prefs = await SharedPreferences.getInstance();
    final onboardingComplete = prefs.getBool('onboarding_complete') ?? false;
    
    if (!onboardingComplete) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      return;
    }

    final authService = AuthService();
    final user = await authService.getCurrentUser();

    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainShell(user: user)));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo tebaba.png',
              height: 250,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Text('🏥', style: TextStyle(fontSize: 80)),
            )
                .animate()
                .scale(duration: 800.ms, curve: Curves.elasticOut)
                .shimmer(delay: 1.seconds, duration: 1.5.seconds),
            const SizedBox(height: 20),
            const Text(
              'طِبابة',
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: AppColors.primary),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),
            const SizedBox(height: 10),
            const Text(
              'نظام نمو العيادات الذكي',
              style: TextStyle(color: Colors.white54, letterSpacing: 2),
            ).animate().fadeIn(delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
