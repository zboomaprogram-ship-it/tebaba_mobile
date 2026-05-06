import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfitabilityScreen extends StatefulWidget {
  const ProfitabilityScreen({super.key});

  @override
  State<ProfitabilityScreen> createState() => _ProfitabilityScreenState();
}

class _ProfitabilityScreenState extends State<ProfitabilityScreen> {
  final _serviceNameController = TextEditingController();
  final _revenueController = TextEditingController();
  final _costController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final revenue = double.tryParse(_revenueController.text) ?? 0;
    final cost = double.tryParse(_costController.text) ?? 0;

    if (revenue <= 0) return;

    final profit = revenue - cost;
    final margin = (profit / revenue) * 100;

    setState(() {
      _result = {
        'profit': profit.toStringAsFixed(0),
        'margin': margin.toStringAsFixed(1),
        'status': margin > 40 ? 'ربحية عالية' : margin > 20 ? 'ربحية متوسطة' : 'هامش منخفض',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل ربحية الخدمات', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildField('اسم الخدمة الطبية', _serviceNameController, '', isText: true),
          const SizedBox(height: 20),
          _buildField('سعر بيع الخدمة', _revenueController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('إجمالي تكلفة الخدمة', _costController, 'ج.م'),
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
              child: const Text('تحليل الربحية', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, String suffix, {bool isText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: isText ? TextInputType.text : TextInputType.number,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(FontAwesomeIcons.moneyBillTrendUp, color: Color(0xFF1DD9A0), size: 18),
              const SizedBox(width: 10),
              Text('تحليل خدمة ${_serviceNameController.text}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1DD9A0))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('صافي الربح للخدمة', '${_result!['profit']} ج.م', Colors.white),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('هامش الربح', '${_result!['margin']}%', const Color(0xFF1DD9A0)),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('التصنيف المالي', _result!['status'], Colors.orangeAccent),
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
