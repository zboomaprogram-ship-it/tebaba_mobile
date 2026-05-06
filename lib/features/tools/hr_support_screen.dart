import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HrSupportScreen extends StatefulWidget {
  const HrSupportScreen({super.key});

  @override
  State<HrSupportScreen> createState() => _HrSupportScreenState();
}

class _HrSupportScreenState extends State<HrSupportScreen> {
  final _salaryController = TextEditingController();
  final _expectedPatientsController = TextEditingController();
  final _avgServicePriceController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final salary = double.tryParse(_salaryController.text) ?? 0;
    final patients = double.tryParse(_expectedPatientsController.text) ?? 0;
    final price = double.tryParse(_avgServicePriceController.text) ?? 0;

    if (salary <= 0 || price <= 0) return;

    final grossRevenue = patients * price;
    final netImpact = grossRevenue - salary;
    final roi = (netImpact / salary) * 100;

    setState(() {
      _result = {
        'revenue': grossRevenue.toStringAsFixed(0),
        'impact': netImpact.toStringAsFixed(0),
        'roi': roi.toStringAsFixed(1),
        'decision': netImpact > 0 ? 'توظيف مربح' : 'خسارة تشغيلية',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دعم قرار التوظيف', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputCard(),
            const SizedBox(height: 30),
            if (_result != null) _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          _buildField('الراتب الشهري للموظف الجديد', _salaryController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('عدد المرضى الإضافي المتوقع', _expectedPatientsController, 'مريض'),
          const SizedBox(height: 20),
          _buildField('متوسط سعر الخدمة', _avgServicePriceController, 'ج.م'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0C040),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('تحليل الجدوى البشرية', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String suffix) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
            suffixText: suffix,
            suffixStyle: const TextStyle(color: Colors.white38),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFFF0C040).withOpacity(0.15), Colors.transparent],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFF0C040).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.userPlus, color: Color(0xFFF0C040), size: 18),
              SizedBox(width: 10),
              Text('نتائج تحليل التوظيف', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF0C040))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('الإيراد الإضافي المتوقع', '${_result!['revenue']} ج.م', Colors.white),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('صافي التأثير المالي', '${_result!['impact']} ج.م', const Color(0xFF1DD9A0)),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('التوصية النهائية', _result!['decision'], Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white54)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}
