import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tebaba_mobile/services/pdf_service.dart';
import 'package:tebaba_mobile/shared/widgets/app_background.dart';
import 'package:tebaba_mobile/core/theme/app_colors.dart';

class ReportScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const ReportScreen({super.key, required this.data});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool _isDownloading = false;

  Future<void> _handleDownload() async {
    setState(() => _isDownloading = true);
    final success = await PdfService().generateAndPrintReport(widget.data);
    setState(() => _isDownloading = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'تم تجهيز التقرير بنجاح'
              : 'حدث خطأ أثناء إعداد التقرير، يرجى التحقق من اتصالك بالإنترنت',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: success ? Colors.green : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final scores = data['scores'] as Map<String, dynamic>? ?? {};
    final overallScore = int.tryParse(data['overall_score'].toString()) ?? 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('تقرير تحليل طِبابة AI'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _isDownloading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: _handleDownload,
                ),
        ],
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildOverallScore(
                overallScore,
                data['overall_status'] ?? 'تحليل معلق',
              ),
              const SizedBox(height: 30),
              _buildMissedRevenueCard(
                data['missed_revenue'] ?? 0,
                data['currency'] ?? 'ريال',
              ),
              const SizedBox(height: 20),
              _buildExecutiveSummary(data['executive_summary']),
              const SizedBox(height: 30),
              _buildSectionHeader(
                'مؤشرات الأداء التفصيلية',
                FontAwesomeIcons.chartPie,
              ),
              const SizedBox(height: 15),
              _buildKpiGrid(scores),
              const SizedBox(height: 30),
              _buildSectionHeader(
                'بصمة الأداء الشامل',
                FontAwesomeIcons.bullseye,
              ),
              const SizedBox(height: 15),
              _buildRadarChart(scores),
              const SizedBox(height: 30),
              _buildSectionHeader(
                'مقارنة الأداء بالهدف',
                FontAwesomeIcons.chartBar,
              ),
              const SizedBox(height: 15),
              _buildBarChart(scores),
              const SizedBox(height: 30),
              _buildSectionHeader(
                'توقعات الأداء المستقبلي',
                FontAwesomeIcons.chartLine,
              ),
              const SizedBox(height: 15),
              _buildLineChart(overallScore),
              const SizedBox(height: 30),
              _buildSectionHeader(
                'خطة العمل المقترحة',
                FontAwesomeIcons.listCheck,
              ),
              const SizedBox(height: 15),
              _buildActionPlan(data['action_steps'] ?? []),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScore(int score, String status) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  value: score / 100,
                  strokeWidth: 10,
                  backgroundColor: Colors.white10,
                  color: AppColors.primary,
                ),
              ),
              Text(
                '$score',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'تحليل شامل لأداء عيادتك بناءً على معايير التشغيل الطبي.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummary(String? summary) {
    if (summary == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(FontAwesomeIcons.brain, size: 16, color: Color(0xFF1DD9A0)),
              SizedBox(width: 10),
              Text(
                'الملخص التنفيذي (AI)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: const TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedRevenueCard(dynamic missed, String currency) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.withValues(alpha: 0.15), Colors.transparent],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          const Text(
            'الفرص الضائعة شهرياً',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            '${missed.toString()} $currency',
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.red,
            ),
          ),
          const Text(
            'خسارة تقديرية بسبب ثغرات التشغيل',
            style: TextStyle(fontSize: 12, color: Colors.white38),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF4D9FFF)),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildKpiGrid(Map<String, dynamic> scores) {
    final kpis = [
      {
        'label': 'التسويق',
        'val': scores['marketing'],
        'color': const Color(0xFFF0C040),
      },
      {
        'label': 'التشغيل',
        'val': scores['operations'],
        'color': const Color(0xFFFF5566),
      },
      {
        'label': 'المالي',
        'val': scores['financial'],
        'color': AppColors.primary,
      },
      {
        'label': 'تجربة المريض',
        'val': scores['experience'],
        'color': const Color(0xFF4D9FFF),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: kpis.length,
      itemBuilder: (context, index) {
        final kpi = kpis[index];
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1221),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kpi['label'] as String,
                style: const TextStyle(fontSize: 12, color: Colors.white54),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${kpi['val']}%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kpi['color'] as Color,
                    ),
                  ),
                  CircularProgressIndicator(
                    value: (double.tryParse(kpi['val'].toString()) ?? 0) / 100,
                    strokeWidth: 3,
                    color: kpi['color'] as Color,
                    backgroundColor: Colors.white10,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadarChart(Map<String, dynamic> scores) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221),
        borderRadius: BorderRadius.circular(25),
      ),
      child: RadarChart(
        RadarChartData(
          dataSets: [
            RadarDataSet(
              fillColor: AppColors.primary.withValues(alpha: 0.2),
              borderColor: AppColors.primary,
              entryRadius: 3,
              dataEntries: [
                RadarEntry(
                  value: (double.tryParse(scores['marketing'].toString()) ?? 0),
                ),
                RadarEntry(
                  value:
                      (double.tryParse(scores['operations'].toString()) ?? 0),
                ),
                RadarEntry(
                  value: (double.tryParse(scores['financial'].toString()) ?? 0),
                ),
                RadarEntry(
                  value: (double.tryParse(scores['team'].toString()) ?? 0),
                ),
                RadarEntry(
                  value: (double.tryParse(scores['growth'].toString()) ?? 0),
                ),
                RadarEntry(
                  value:
                      (double.tryParse(scores['experience'].toString()) ?? 0),
                ),
              ],
            ),
          ],
          radarBackgroundColor: Colors.transparent,
          gridBorderData: const BorderSide(color: Colors.white10),
          tickBorderData: const BorderSide(color: Colors.white10),
          ticksTextStyle: const TextStyle(color: Colors.white24, fontSize: 10),
          getTitle: (index, angle) {
            final labels = ['تسويق', 'تشغيل', 'مالي', 'فريق', 'نمو', 'مريض'];
            return RadarChartTitle(text: labels[index], angle: angle);
          },
          titleTextStyle: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildActionPlan(List<dynamic> steps) {
    return Column(
      children: steps.map((step) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFF0B1221),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Icon(Icons.check, color: AppColors.primary, size: 18),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step['title'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step['desc'] ?? '',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                step['gain'] ?? '',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(Map<String, dynamic> scores) {
    final targets = [80.0, 80.0, 95.0, 80.0, 75.0, 80.0];
    final current = [
      (double.tryParse(scores['marketing'].toString()) ?? 0),
      (double.tryParse(scores['operations'].toString()) ?? 0),
      (double.tryParse(scores['financial'].toString()) ?? 0),
      (double.tryParse(scores['team'].toString()) ?? 0),
      (double.tryParse(scores['growth'].toString()) ?? 0),
      (double.tryParse(scores['experience'].toString()) ?? 0),
    ];
    final labels = ['تسويق', 'تشغيل', 'مالي', 'فريق', 'نمو', 'مريض'];

    return Container(
      height: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('الأداء الحالي', AppColors.primary),
              const SizedBox(width: 20),
              _buildLegendItem('الهدف', Colors.white.withValues(alpha: 0.2)),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => const Color(0xFF1A2235),
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${labels[groupIndex]}\n',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '${rod.toY.round()}%',
                            style: TextStyle(
                              color: rodIndex == 0
                                  ? Colors.white54
                                  : AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            labels[value.toInt()],
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      reservedSize: 32,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 25,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withValues(alpha: 0.05),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(6, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: targets[i],
                        color: Colors.white.withValues(alpha: 0.08),
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      BarChartRodData(
                        toY: current[i],
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.5),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        width: 12,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                          toY: 100,
                          color: Colors.white.withValues(alpha: 0.02),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(int overallScore) {
    final rawProjAfter = [
      overallScore.toDouble(),
      (overallScore + 7).toDouble(),
      (overallScore + 15).toDouble(),
      (overallScore + 22).toDouble(),
      (overallScore + 30).toDouble(),
      100.0,
    ];
    final rawProjBefore = [
      overallScore.toDouble(),
      (overallScore - 3).toDouble(),
      (overallScore - 6).toDouble(),
      (overallScore - 10).toDouble(),
      (overallScore - 15).toDouble(),
      (overallScore - 20).toDouble(),
    ];

    double maxProj = rawProjAfter.reduce(
      (curr, next) => curr > next ? curr : next,
    );
    if (rawProjBefore.reduce((curr, next) => curr > next ? curr : next) >
        maxProj) {
      maxProj = rawProjBefore.reduce((curr, next) => curr > next ? curr : next);
    }

    final after = maxProj > 100
        ? rawProjAfter.map((v) => (v / maxProj) * 100).toList()
        : rawProjAfter.map((v) => v.clamp(0.0, 100.0)).toList();
    final before = maxProj > 100
        ? rawProjBefore.map((v) => (v / maxProj) * 100).toList()
        : rawProjBefore.map((v) => v.clamp(0.0, 100.0)).toList();

    final labels = ['الآن', 'ش1', 'ش2', 'ش3', 'ش6', 'ش12'];

    return Container(
      height: 380,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('بعد التحسين', AppColors.primary),
              const SizedBox(width: 20),
              _buildLegendItem('بدون تدخل', Colors.redAccent),
            ],
          ),
          const SizedBox(height: 30),
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => const Color(0xFF1A2235),
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.barIndex == 0
                              ? Colors.redAccent
                              : AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          '${touchedSpot.y.round()}%',
                          textStyle,
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 25,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.white.withValues(alpha: 0.05),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.white.withValues(alpha: 0.02),
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        int idx = value.toInt();
                        if (idx >= 0 && idx < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              labels[idx],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox.shrink();
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 5,
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      6,
                      (i) => FlSpot(i.toDouble(), before[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: Colors.redAccent.withValues(alpha: 0.8),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 4,
                            color: const Color(0xFF0B1221),
                            strokeColor: Colors.redAccent,
                            strokeWidth: 2,
                          ),
                    ),
                    belowBarData: BarAreaData(show: false),
                    dashArray: [5, 5],
                  ),
                  LineChartBarData(
                    spots: List.generate(
                      6,
                      (i) => FlSpot(i.toDouble(), after[i]),
                    ),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withValues(alpha: 0.8),
                        AppColors.primary,
                      ],
                    ),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    shadow: Shadow(
                      color: AppColors.primary.withValues(alpha: 0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                            radius: 5,
                            color: AppColors.primary,
                            strokeColor: Colors.white,
                            strokeWidth: 2,
                          ),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.3),
                          AppColors.primary.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
