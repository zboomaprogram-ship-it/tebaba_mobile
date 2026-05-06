import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AiOverlay extends StatelessWidget {
  final String clinicName;

  const AiOverlay({super.key, required this.clinicName});

  @override
  Widget build(BuildContext context) {
    final steps = [
      'جاري تجميع البيانات...',
      'تحليل المؤشرات المالية والتشغيلية...',
      'مقارنة الأداء بمعايير السوق الطبي...',
      'توليد خطة العمل والتوصيات...',
    ];

    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🧠', style: TextStyle(fontSize: 80))
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 1.seconds)
                .shimmer(delay: 500.ms, duration: 2.seconds),
            const SizedBox(height: 30),
            const Text(
              'طِبابة AI يحلل بياناتك',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1DD9A0)),
            ),
            const SizedBox(height: 10),
            Text(
              'جارٍ إنشاء التقرير لعيادة $clinicName',
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps.asMap().entries.map((entry) {
                  final index = entry.key;
                  final step = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF1DD9A0), size: 20),
                        const SizedBox(width: 10),
                        Text(
                          step,
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ).animate().fadeIn(delay: (index * 800).ms).slideX(begin: -0.1, end: 0),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: const LinearProgressIndicator(
                backgroundColor: Colors.white10,
                color: Color(0xFF1DD9A0),
              ).animate().fadeIn(delay: 500.ms),
            ),
          ],
        ),
      ),
    );
  }
}
