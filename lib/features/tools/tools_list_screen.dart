import 'package:flutter/material.dart';
import 'package:tebaba_mobile/features/tools/roi_calculator_screen.dart';
import 'package:tebaba_mobile/features/tools/cac_calculator_screen.dart';
import 'package:tebaba_mobile/features/tools/ops_efficiency_screen.dart';
import 'package:tebaba_mobile/features/tools/pricing_engine_screen.dart';
import 'package:tebaba_mobile/features/tools/profitability_screen.dart';
import 'package:tebaba_mobile/features/tools/expansion_study_screen.dart';
import 'package:tebaba_mobile/features/tools/hr_support_screen.dart';
import 'package:tebaba_mobile/features/tools/inventory_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tebaba_mobile/core/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToolsListScreen extends StatelessWidget {
  const ToolsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tools = [
      {'id': 'roi', 'title': 'العائد الاستثماري', 'icon': FontAwesomeIcons.stethoscope, 'cat': 'Finance', 'desc': 'قياس العائد للأصول الطبية'},
      {'id': 'cac', 'title': 'تكلفة جذب المريض', 'icon': FontAwesomeIcons.bullseye, 'cat': 'Marketing', 'desc': 'احسب تكلفة كل مريض بدقة'},
      {'id': 'ops', 'title': 'كفاءة التشغيل', 'icon': FontAwesomeIcons.bolt, 'cat': 'Operations', 'desc': 'تقييم السعة الاستيعابية'},
      {'id': 'pricing', 'title': 'تحديد الأسعار', 'icon': FontAwesomeIcons.coins, 'cat': 'Strategy', 'desc': 'محرك ذكي للأسعار المثلى'},
      {'id': 'profit', 'title': 'ربحية الخدمات', 'icon': FontAwesomeIcons.chartSimple, 'cat': 'Analytics', 'desc': 'تحليل ربحية كل خدمة'},
      {'id': 'expansion', 'title': 'دراسة التوسع', 'icon': FontAwesomeIcons.map, 'cat': 'Expansion', 'desc': 'جدوى فتح فروع جديدة'},
      {'id': 'hr', 'title': 'دعم التوظيف', 'icon': FontAwesomeIcons.users, 'cat': 'HR', 'desc': 'قرار التوظيف الذكي'},
      {'id': 'inventory', 'title': 'إدارة المخزون', 'icon': FontAwesomeIcons.box, 'cat': 'Inventory', 'desc': 'نظام المخزون الطبي'},
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('أدوات النمو', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.85,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
        ),
        itemCount: tools.length,
        itemBuilder: (context, index) {
          final tool = tools[index];
          return GestureDetector(
            onTap: () {
              Widget screen;
              switch (index) {
                case 0: screen = const RoiCalculatorScreen(); break;
                case 1: screen = const CacCalculatorScreen(); break;
                case 2: screen = const OpsEfficiencyScreen(); break;
                case 3: screen = const PricingEngineScreen(); break;
                case 4: screen = const ProfitabilityScreen(); break;
                case 5: screen = const ExpansionStudyScreen(); break;
                case 6: screen = const HrSupportScreen(); break;
                case 7: screen = const InventoryScreen(); break;
                default: return;
              }
              Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1221),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      tool['cat'] as String,
                      style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Icon(tool['icon'] as IconData, size: 32, color: AppColors.primary),
                  const SizedBox(height: 10),
                  Text(
                    tool['title'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    tool['desc'] as String,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 10, color: Colors.white38),
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(delay: (index * 100).ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
        },
      ),
    );
  }
}
