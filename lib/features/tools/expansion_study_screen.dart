import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ExpansionStudyScreen extends StatefulWidget {
  const ExpansionStudyScreen({super.key});

  @override
  State<ExpansionStudyScreen> createState() => _ExpansionStudyScreenState();
}

class _ExpansionStudyScreenState extends State<ExpansionStudyScreen> {
  final _setupCostController = TextEditingController();
  final _expectedMonthlyRevenueController = TextEditingController();
  final _monthlyOpCostController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final setup = double.tryParse(_setupCostController.text) ?? 0;
    final revenue = double.tryParse(_expectedMonthlyRevenueController.text) ?? 0;
    final opCost = double.tryParse(_monthlyOpCostController.text) ?? 0;

    if (setup <= 0 || revenue <= 0) return;

    final monthlyProfit = revenue - opCost;
    if (monthlyProfit <= 0) {
      setState(() {
        _result = {'error': 'المصاريف التشغيلية أعلى من الإيرادات المتوقعة!'};
      });
      return;
    }

    final breakEvenMonths = setup / monthlyProfit;
    final annualRoi = (monthlyProfit * 12 / setup) * 100;

    setState(() {
      _result = {
        'profit': monthlyProfit.toStringAsFixed(0),
        'be': breakEvenMonths.toStringAsFixed(1),
        'roi': annualRoi.toStringAsFixed(1),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دراسة جدوى التوسع', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildField('تكلفة التأسيس والتجهيزات', _setupCostController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('الإيراد الشهري المتوقع للفرع', _expectedMonthlyRevenueController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('المصاريف التشغيلية الشهرية', _monthlyOpCostController, 'ج.م'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4D9FFF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('بدء دراسة الجدوى', style: TextStyle(fontWeight: FontWeight.bold)),
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
    if (_result!.containsKey('error')) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
        child: Text(_result!['error'], style: const TextStyle(color: Colors.redAccent)),
      );
    }
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
              Icon(FontAwesomeIcons.mapLocationDot, color: Color(0xFF4D9FFF), size: 18),
              SizedBox(width: 10),
              Text('نتائج التوسع التقديرية', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4D9FFF))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('الربح الصافي الشهري', '${_result!['profit']} ج.م', Colors.white),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('فترة استرداد الاستثمار', '${_result!['be']} شهر', const Color(0xFF1DD9A0)),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('العائد السنوي المتوقع', '${_result!['roi']}%', Colors.orangeAccent),
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
