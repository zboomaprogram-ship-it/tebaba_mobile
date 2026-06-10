import 'package:flutter/material.dart';
import 'package:tebaba_mobile/features/health_check/diagnostic_form_screen.dart';
import 'package:tebaba_mobile/shared/widgets/landing_sections.dart';
import 'package:tebaba_mobile/features/health_check/history_screen.dart';
import 'package:tebaba_mobile/features/auth/profile_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tebaba_mobile/core/theme/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _clinicNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _clinicNameController.dispose();
    super.dispose();
  }

  void _startDiagnostic() {
    if (_clinicNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('برجاء إدخال اسم العيادة للمتابعة')),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DiagnosticFormScreen(clinicName: _clinicNameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero()
                .animate()
                .fadeIn(duration: 800.ms)
                .slideY(begin: 0.2, end: 0),
            const SizedBox(height: 50),
            LandingSections.buildWhy()
                .animate()
                .fadeIn(delay: 100.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 80),
            LandingSections.buildJourney()
                .animate()
                .fadeIn(delay: 200.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 80),
            LandingSections.buildSystems()
                .animate()
                .fadeIn(delay: 400.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 80),
            LandingSections.buildAIExplain()
                .animate()
                .fadeIn(delay: 500.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 80),
            LandingSections.buildMetrics()
                .animate()
                .fadeIn(delay: 600.ms)
                .slideY(begin: 0.1, end: 0),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.5,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo tebaba.png',
                height: 130,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Text('🏥', style: TextStyle(fontSize: 32)),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(FontAwesomeIcons.clockRotateLeft, color: Colors.white54, size: 20),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HistoryScreen(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(user: widget.user),
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: Icon(FontAwesomeIcons.solidUser, color: AppColors.primary, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            'أهلاً بك يا ${widget.user['full_name']}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            'جاهز لتطوير بزنسك الطبي؟',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'مدقق صحة البزنس الطبي',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'تقرير AI يكشف ثغرات تشغيلية ومالية في مركزك خلال دقائق',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _clinicNameController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'ادخل اسم عيادتك هنا',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    filled: true,
                    fillColor: Colors.black26,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(20),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child:
                      ElevatedButton(
                            onPressed: _startDiagnostic,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text(
                              'افحص بزنسك الآن 🚀',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          )
                          .animate(
                            onPlay: (controller) =>
                                controller.repeat(reverse: true),
                          )
                          .shimmer(
                            delay: 2.seconds,
                            duration: 1.5.seconds,
                            color: Colors.white24,
                          )
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.02, 1.02),
                            duration: 1.seconds,
                            curve: Curves.easeInOut,
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
