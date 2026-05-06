import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _usageController = TextEditingController();
  final _leadTimeController = TextEditingController();
  final _unitCostController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final usage = double.tryParse(_usageController.text) ?? 0;
    final leadTime = double.tryParse(_leadTimeController.text) ?? 0;
    final unitCost = double.tryParse(_unitCostController.text) ?? 0;

    if (usage <= 0 || leadTime <= 0) return;

    // Daily usage * lead time + 20% safety stock
    final reorderPoint = (usage / 30) * leadTime * 1.2;
    final annualHoldingCost = usage * 12 * unitCost * 0.1; // Assuming 10% holding cost

    setState(() {
      _result = {
        'reorder': reorderPoint.toStringAsFixed(0),
        'holding': annualHoldingCost.toStringAsFixed(0),
        'status': 'مستقر',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المخزون الطبي', style: TextStyle(fontWeight: FontWeight.bold)),
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
          _buildField('الاستهلاك الشهري (كمية)', _usageController, 'وحدة'),
          const SizedBox(height: 20),
          _buildField('فترة التوريد (Lead Time)', _leadTimeController, 'يوم'),
          const SizedBox(height: 20),
          _buildField('تكلفة الوحدة الواحدة', _unitCostController, 'ج.م'),
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
              child: const Text('حساب نقطة إعادة الطلب', style: TextStyle(fontWeight: FontWeight.bold)),
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
              Icon(FontAwesomeIcons.boxesStacked, color: Color(0xFF1DD9A0), size: 18),
              SizedBox(width: 10),
              Text('توصيات إدارة المخزون', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1DD9A0))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('نقطة إعادة الطلب', '${_result!['reorder']} وحدة', const Color(0xFF1DD9A0)),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('تكلفة التخزين السنوية', '${_result!['holding']} ج.م', Colors.orangeAccent),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('حالة التوريد', _result!['status'], Colors.white),
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
