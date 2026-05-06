import 'package:flutter/material.dart';
import 'package:tebaba_mobile/services/analysis_service.dart';
import 'package:tebaba_mobile/features/report/report_screen.dart';
import 'package:tebaba_mobile/shared/widgets/ai_overlay.dart';
import 'package:tebaba_mobile/shared/widgets/app_background.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DiagnosticFormScreen extends StatefulWidget {
  final String clinicName;
  const DiagnosticFormScreen({super.key, required this.clinicName});

  @override
  State<DiagnosticFormScreen> createState() => _DiagnosticFormScreenState();
}

class _DiagnosticFormScreenState extends State<DiagnosticFormScreen> {
  int _currentStep = 0;
  final _analysisService = AnalysisService();
  bool _isAnalyzing = false;

  final Map<String, TextEditingController> _controllers = {};

  final Map<String, dynamic> _formData = {
    'type': '',
    'specialty': '',
    'revenue': '',
    'patients': '',
    'price': '',
    'doctors': '',
    'noshow': '',
    'crm': '',
    'response': '',
    'retention': '',
    'booking': '',
    'mktbudget': '',
    'instagram': '',
    'source': '',
    'goal': '',
    'currency': 'ج.م',
    'phone': '',
    'countryCode': '+20',
  };

  @override
  void initState() {
    super.initState();
    // Initialize controllers for numeric and text fields
    [
      'revenue',
      'patients',
      'price',
      'noshow',
      'retention',
      'mktbudget',
      'phone',
    ].forEach((key) {
      _controllers[key] = TextEditingController();
    });
  }

  @override
  void dispose() {
    _controllers.values.forEach((c) => c.dispose());
    super.dispose();
  }

  bool _validateCurrentStep() {
    final step1Required = ['type', 'specialty', 'revenue', 'patients', 'price', 'doctors'];
    final step2Required = ['noshow', 'crm', 'response', 'retention', 'booking'];
    final step3Required = ['mktbudget', 'instagram', 'source', 'goal'];

    final List<String> currentFields;
    if (_currentStep == 0) {
      currentFields = step1Required;
    } else if (_currentStep == 1) {
      currentFields = step2Required;
    } else {
      currentFields = step3Required;
    }

    for (final field in currentFields) {
      final val = _formData[field]?.toString().trim() ?? '';
      if (val.isEmpty) {
        _showError('برجاء إكمال جميع الخانات المطلوبة قبل المتابعة');
        return false;
      }
    }
    return true;
  }

  void _nextStep() {
    if (!_validateCurrentStep()) return;

    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _runAnalysis();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _runAnalysis() async {
    setState(() => _isAnalyzing = true);

    try {
      final report = await _analysisService.runAiAnalysis(
        widget.clinicName,
        _formData,
      );
      await _analysisService.saveAnalysis(
        clinicName: widget.clinicName,
        formData: _formData,
        reportData: report,
      );

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReportScreen(data: report)),
      );
    } catch (e) {
      _showError('خطأ: فشل تحليل البيانات، تأكد من الاتصال وحاول مرة أخرى');
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030A10),
      appBar: AppBar(
        title: Text('فحص عيادة ${widget.clinicName}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AppBackground(
        child: _isAnalyzing ? _buildLoadingOverlay() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildProgressBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (_currentStep == 0)
                  _buildStep1(
                    key: const ValueKey('step1'),
                  ).animate().fadeIn().slideX(begin: 0.1, end: 0),
                if (_currentStep == 1)
                  _buildStep2(
                    key: const ValueKey('step2'),
                  ).animate().fadeIn().slideX(begin: 0.1, end: 0),
                if (_currentStep == 2)
                  _buildStep3(
                    key: const ValueKey('step3'),
                  ).animate().fadeIn().slideX(begin: 0.1, end: 0),
              ],
            ),
          ),
        ),
        _buildNavigationButtons(),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: List.generate(3, (index) {
          bool isActive = index == _currentStep;
          bool isDone = index < _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isDone
                    ? const Color(0xFF1DD9A0)
                    : (isActive
                          ? const Color(0xFF1DD9A0).withOpacity(0.5)
                          : Colors.white10),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader('بيانات البزنس', '🏥'),
        const SizedBox(height: 20),
        _buildDropdown('نوع المركز', 'type', [
          const DropdownMenuItem(value: 'clinic', child: Text('عيادة خاصة')),
          const DropdownMenuItem(value: 'center', child: Text('مركز طبي')),
          const DropdownMenuItem(value: 'hospital', child: Text('مستشفى صغير')),
          const DropdownMenuItem(value: 'chain', child: Text('سلسلة عيادات')),
        ]),
        const SizedBox(height: 15),
        _buildDropdown('التخصص الأساسي', 'specialty', [
          const DropdownMenuItem(value: 'dental', child: Text('أسنان')),
          const DropdownMenuItem(value: 'derma', child: Text('جلدية وتجميل')),
          const DropdownMenuItem(value: 'eyes', child: Text('عيون')),
          const DropdownMenuItem(value: 'ortho', child: Text('عظام')),
          const DropdownMenuItem(value: 'pedia', child: Text('أطفال')),
          const DropdownMenuItem(value: 'gyne', child: Text('نسا وتوليد')),
          const DropdownMenuItem(value: 'internal', child: Text('باطنة')),
          const DropdownMenuItem(value: 'cardio', child: Text('قلب')),
          const DropdownMenuItem(value: 'neuro', child: Text('أعصاب')),
          const DropdownMenuItem(value: 'other', child: Text('تخصص آخر')),
        ]),
        const SizedBox(height: 15),
        _buildTextField(
          'الإيراد الشهري',
          'revenue',
          icon: FontAwesomeIcons.moneyBill,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          'مرضى جدد شهرياً',
          'patients',
          icon: FontAwesomeIcons.users,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        _buildTextField(
          'متوسط سعر الخدمة',
          'price',
          icon: FontAwesomeIcons.tag,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        _buildDropdown('عدد الأطباء العاملين', 'doctors', [
          const DropdownMenuItem(value: '1', child: Text('طبيب واحد')),
          const DropdownMenuItem(value: '2-3', child: Text('2 - 3 أطباء')),
          const DropdownMenuItem(value: '4-6', child: Text('4 - 6 أطباء')),
          const DropdownMenuItem(value: '7+', child: Text('7 أطباء أو أكثر')),
        ]),
      ],
    );
  }

  Widget _buildStep2({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader('الأداء التشغيلي', '⚙️'),
        const SizedBox(height: 20),
        _buildTextField(
          'نسبة No-Show %',
          'noshow',
          icon: FontAwesomeIcons.xmark,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        _buildDropdown('هل لديك CRM؟', 'crm', [
          const DropdownMenuItem(value: 'none', child: Text('لا يوجد')),
          const DropdownMenuItem(value: 'excel', child: Text('Excel / ورقي')),
          const DropdownMenuItem(value: 'basic', child: Text('نظام بسيط')),
          const DropdownMenuItem(value: 'advanced', child: Text('نظام متقدم')),
        ]),
        const SizedBox(height: 15),
        _buildDropdown('سرعة الرد على الاستفسارات', 'response', [
          const DropdownMenuItem(value: 'slow', child: Text('بطيء (+4 ساعات)')),
          const DropdownMenuItem(
            value: 'medium',
            child: Text('متوسط (1-4 ساعات)'),
          ),
          const DropdownMenuItem(
            value: 'fast',
            child: Text('سريع (أقل من ساعة)'),
          ),
          const DropdownMenuItem(value: 'instant', child: Text('فوري (أتمتة)')),
        ]),
        const SizedBox(height: 15),
        _buildTextField(
          'نسبة المرضى العائدين %',
          'retention',
          icon: FontAwesomeIcons.rotate,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        _buildDropdown('طريقة الحجز الأساسية', 'booking', [
          const DropdownMenuItem(value: 'phone', child: Text('تليفون')),
          const DropdownMenuItem(value: 'online', child: Text('أونلاين')),
          const DropdownMenuItem(value: 'mixed', child: Text('متنوع')),
        ]),
        const SizedBox(height: 15),
        const Text(
          'رقم الواتساب',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _formData['countryCode'],
                  items: const [
                    DropdownMenuItem(value: '+20', child: Text('🇪🇬 +20')),
                    DropdownMenuItem(value: '+966', child: Text('🇸🇦 +966')),
                    DropdownMenuItem(value: '+971', child: Text('🇦🇪 +971')),
                    DropdownMenuItem(value: '+965', child: Text('🇰🇼 +965')),
                    DropdownMenuItem(value: '+974', child: Text('🇶🇦 +974')),
                    DropdownMenuItem(value: '+968', child: Text('🇴🇲 +968')),
                    DropdownMenuItem(value: '+973', child: Text('🇧🇭 +973')),
                  ],
                  onChanged: (v) => setState(() => _formData['countryCode'] = v),
                  dropdownColor: const Color(0xFF0B1221),
                  style: const TextStyle(color: Colors.white),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1DD9A0)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: TextField(
                  controller: _controllers['phone'],
                  onChanged: (v) => _formData['phone'] = v,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(FontAwesomeIcons.whatsapp, size: 18, color: Color(0xFF1DD9A0)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3({Key? key}) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader('التسويق والنمو', '📈'),
        const SizedBox(height: 20),
        _buildTextField(
          'ميزانية التسويق',
          'mktbudget',
          icon: FontAwesomeIcons.creditCard,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        _buildDropdown('نشاط Instagram', 'instagram', [
          const DropdownMenuItem(value: 'inactive', child: Text('غير نشط')),
          const DropdownMenuItem(value: 'basic', child: Text('أساسي')),
          const DropdownMenuItem(value: 'active', child: Text('نشاط قوي')),
        ]),
        const SizedBox(height: 15),
        _buildDropdown('مصدر المرضى الجدد', 'source', [
          const DropdownMenuItem(value: 'referral', child: Text('إحالة')),
          const DropdownMenuItem(value: 'ads', child: Text('إعلانات مدفوعة')),
          const DropdownMenuItem(value: 'mixed', child: Text('متنوع')),
        ]),
        const SizedBox(height: 15),
        _buildDropdown('هدف النمو (12 شهر)', 'goal', [
          const DropdownMenuItem(
            value: 'maintain',
            child: Text('الحفاظ على الوضع'),
          ),
          const DropdownMenuItem(value: 'grow20', child: Text('نمو 20-50%')),
          const DropdownMenuItem(value: 'grow50', child: Text('نمو 50-80%')),
          const DropdownMenuItem(value: 'scale', child: Text('توسع ومضاعفة')),
        ]),
      ],
    );
  }

  Widget _buildHeader(String title, String icon) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String key, {
    IconData? icon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: _controllers[key],
            onChanged: (v) => _formData[key] = v,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: icon != null
                  ? Icon(icon, size: 18, color: const Color(0xFF1DD9A0))
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(15),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    String key,
    List<DropdownMenuItem<String>> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _formData[key].isEmpty ? null : _formData[key],
              items: items,
              onChanged: (v) => setState(() => _formData[key] = v),
              dropdownColor: const Color(0xFF0B1221),
              isExpanded: true,
              hint: const Text('اختر'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  'رجوع',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 15),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DD9A0),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                _currentStep == 2 ? 'توليد التقرير 🩺' : 'التالي ←',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return AiOverlay(clinicName: widget.clinicName);
  }
}
