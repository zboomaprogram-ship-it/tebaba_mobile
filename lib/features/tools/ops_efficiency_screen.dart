import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OpsEfficiencyScreen extends StatefulWidget {
  const OpsEfficiencyScreen({super.key});

  @override
  State<OpsEfficiencyScreen> createState() => _OpsEfficiencyScreenState();
}

class _OpsEfficiencyScreenState extends State<OpsEfficiencyScreen> {
  final _roomsController = TextEditingController();
  final _doctorsController = TextEditingController();
  final _hoursController = TextEditingController();
  final _appointmentsController = TextEditingController();
  
  Map<String, dynamic>? _result;

  void _calculate() {
    final rooms = double.tryParse(_roomsController.text) ?? 0;
    final doctors = double.tryParse(_doctorsController.text) ?? 0;
    final hours = double.tryParse(_hoursController.text) ?? 8;
    final appointments = double.tryParse(_appointmentsController.text) ?? 0;

    if (rooms <= 0 || doctors <= 0) return;

    // Assuming 20 min per appointment = 3 appointments per hour per room
    final maxCapacity = rooms * hours * 3;
    final utilization = (appointments / maxCapacity) * 100;
    final gap = maxCapacity - appointments;

    setState(() {
      _result = {
        'utilization': utilization.toStringAsFixed(1),
        'max': maxCapacity.toStringAsFixed(0),
        'gap': gap.toStringAsFixed(0),
        'status': utilization > 85 ? 'ضغط عالي' : utilization > 60 ? 'مثالي' : 'غير مستغل',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('كفاءة التشغيل', style: TextStyle(fontWeight: FontWeight.bold)),
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
          Row(
            children: [
              Expanded(child: _buildField('عدد الغرف', _roomsController, '')),
              const SizedBox(width: 15),
              Expanded(child: _buildField('عدد الأطباء', _doctorsController, '')),
            ],
          ),
          const SizedBox(height: 20),
          _buildField('ساعات العمل اليومية', _hoursController, 'ساعة'),
          const SizedBox(height: 20),
          _buildField('إجمالي مواعيد اليوم', _appointmentsController, 'موعد'),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5566), // Red for operations
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('تحليل الطاقة الاستيعابية', style: TextStyle(fontWeight: FontWeight.bold)),
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
          colors: [const Color(0xFFFF5566).withOpacity(0.15), Colors.transparent],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: const Color(0xFFFF5566).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.gears, color: Color(0xFFFF5566), size: 18),
              SizedBox(width: 10),
              Text('نتائج الكفاءة التشغيلية', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF5566))),
            ],
          ),
          const SizedBox(height: 24),
          _buildResultRow('نسبة الإشغال', '${_result!['utilization']}%', Colors.white),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('السعة القصوى (مواعيد)', _result!['max'], const Color(0xFF1DD9A0)),
          const Divider(height: 30, color: Colors.white10),
          _buildResultRow('الفجوة المتاحة للنمو', '${_result!['gap']} موعد', Colors.orangeAccent),
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
