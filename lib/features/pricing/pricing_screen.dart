import 'package:flutter/material.dart';
import 'package:tebaba_mobile/shared/widgets/landing_sections.dart';
import 'package:tebaba_mobile/core/theme/app_colors.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الباقات والأسعار', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                'اختر الخطة المناسبة لنمو عيادتك',
                style: TextStyle(fontSize: 18, color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            LandingSections.buildPricing(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
