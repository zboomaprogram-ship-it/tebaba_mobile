import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CacCalculatorScreen extends StatefulWidget {
  const CacCalculatorScreen({super.key});

  @override
  State<CacCalculatorScreen> createState() => _CacCalculatorScreenState();
}

class _CacCalculatorScreenState extends State<CacCalculatorScreen> {
  final _spendController = TextEditingController();
  final _patientsController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final spend = double.tryParse(_spendController.text) ?? 0;
    final patients = double.tryParse(_patientsController.text) ?? 0;

    if (spend <= 0 || patients <= 0) return;

    final cac = spend / patients;
    final ltvEstimate = cac * 8; // Industry benchmark for health LTV:CAC ratio
    final efficiency = cac < 100 ? 'ممتاز' : cac < 300 ? 'جيد' : 'يحتاج تحسين';

    setState(() {
      _result = {
        'cac': cac.toStringAsFixed(0),
        'ltv': ltvEstimate.toStringAsFixed(0),
        'status': efficiency,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حساب تكلفة جذب المريض', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildField('إجمالي الإنفاق التسويقي', _spendController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('عدد المرضى الجدد المكتسبين', _patientsController, 'مريض'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D9FFF), // Blue for marketing
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('تحليل كفاءة التسويق', style: TextStyle(fontWeight: FontWeight.bold)),
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
          colors: [const Color(0xFF4D9FFF).withOpacity(0.15), Colors.transparent],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF4D9FFF).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.bullseye, color: Color(0xFF4D9FFF), size: 18),
              SizedBox(width: 10),
              Text('نتائج كفاءة الاستحواذ', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4D9FFF))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('تكلفة المريض (CAC)', '${_result!['cac']} ج.م', Colors.white),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('القيمة التقديرية (LTV)', '${_result!['ltv']} ج.م', const Color(0xFF1DD9A0)),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('مستوى الكفاءة', _result!['status'], Colors.orangeAccent),
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
