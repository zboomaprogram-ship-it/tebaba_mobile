import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PricingEngineScreen extends StatefulWidget {
  const PricingEngineScreen({super.key});

  @override
  State<PricingEngineScreen> createState() => _PricingEngineScreenState();
}

class _PricingEngineScreenState extends State<PricingEngineScreen> {
  final _costController = TextEditingController();
  final _overheadController = TextEditingController();
  final _marginController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final cost = double.tryParse(_costController.text) ?? 0;
    final overhead = double.tryParse(_overheadController.text) ?? 0;
    final margin = (double.tryParse(_marginController.text) ?? 30) / 100;

    if (cost <= 0) return;

    final totalCost = cost + overhead;
    final recommended = totalCost / (1 - margin);
    final minimum = totalCost * 1.1; // 10% safety margin

    setState(() {
      _result = {
        'total': totalCost.toStringAsFixed(0),
        'min': minimum.toStringAsFixed(0),
        'rec': recommended.toStringAsFixed(0),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محرك التسعير الذكي', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildField('التكلفة المباشرة (خامات/مستهلكات)', _costController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('نصيب الخدمة من المصاريف الثابتة', _overheadController, 'ج.م'),
          const SizedBox(height: 20),
          _buildField('هامش الربح المستهدف', _marginController, '%'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0C040), // Gold for strategy
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('استخراج السعر الأمثل', style: TextStyle(fontWeight: FontWeight.bold)),
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
              Icon(FontAwesomeIcons.tag, color: Color(0xFFF0C040), size: 18),
              SizedBox(width: 10),
              Text('توصيات التسعير الاستراتيجية', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFF0C040))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('سعر التكلفة الإجمالي', '${_result!['total']} ج.م', Colors.white),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('أقل سعر مقبول (Break-even)', '${_result!['min']} ج.م', Colors.orangeAccent),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('السعر الموصى به للنمو', '${_result!['rec']} ج.م', const Color(0xFF1DD9A0)),
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
