import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RoiCalculatorScreen extends StatefulWidget {
  const RoiCalculatorScreen({super.key});

  @override
  State<RoiCalculatorScreen> createState() => _RoiCalculatorScreenState();
}

class _RoiCalculatorScreenState extends State<RoiCalculatorScreen> {
  final _costController = TextEditingController();
  final _revenueController = TextEditingController();
  final _maintenanceController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final cost = double.tryParse(_costController.text) ?? 0;
    final revenue = double.tryParse(_revenueController.text) ?? 0;
    final maintenance = double.tryParse(_maintenanceController.text) ?? 0;

    if (cost <= 0 || revenue <= 0) return;

    final monthlyProfit = revenue - maintenance;
    final annualRoi = (monthlyProfit * 12 / cost) * 100;
    final paybackMonths = cost / monthlyProfit;

    setState(() {
      _result = {
        'profit': monthlyProfit.toStringAsFixed(0),
        'roi': annualRoi.toStringAsFixed(1),
        'payback': paybackMonths.toStringAsFixed(1),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ROI للأصول الطبية', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildField('تكلفة الجهاز / الأصل', _costController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('الإيراد الشهري المتوقع', _revenueController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('تكاليف الصيانة والتشغيل شهرياً', _maintenanceController, 'ج.م'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1DD9A0),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('احسب العائد الآن', style: TextStyle(fontWeight: FontWeight.bold)),
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
          colors: [const Color(0xFF1DD9A0).withOpacity(0.15), Colors.transparent],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFF1DD9A0).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.chartLine, color: Color(0xFF1DD9A0), size: 18),
              SizedBox(width: 10),
              Text('نتائج التحليل الاستثماري', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1DD9A0))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('الربح الصافي الشهري', '${_result!['profit']} ج.م', Colors.white),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('العائد السنوي (ROI)', '${_result!['roi']}%', const Color(0xFF1DD9A0)),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('فترة استرداد رأس المال', '${_result!['payback']} شهر', Colors.orangeAccent),
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
