import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PdfService {
  Future<bool> generateAndPrintReport(Map<String, dynamic> data) async {
    try {
      final pdf = pw.Document();

      // Load a font that supports Arabic - try multiple fallbacks
      pw.Font ttf;
      try {
        final ByteData bytes = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
        ttf = pw.Font.ttf(bytes);
      } catch (e) {
        try {
          final ByteData bytes = await rootBundle.load("packages/google_fonts/fonts/Cairo-Regular.ttf");
          ttf = pw.Font.ttf(bytes);
        } catch (e2) {
          try {
            final response = await http.get(Uri.parse('https://fonts.gstatic.com/s/cairo/v28/SLXGc1nu6HkveRfSBWCp.ttf'));
            if (response.statusCode == 200) {
              ttf = pw.Font.ttf(response.bodyBytes.buffer.asByteData());
            } else {
              throw Exception("Font download failed");
            }
          } catch (e3) {
            // Final fallback to standard font so it doesn't crash, even if Arabic is broken
            ttf = pw.Font.helvetica();
          }
        }
      }

      final scores = data['scores'] as Map<String, dynamic>? ?? {};

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: pw.ThemeData.withFont(base: ttf),
          build: (pw.Context context) {
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: const pw.BoxDecoration(color: PdfColors.teal),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'طِبابة - تقرير نمو البزنس الطبي',
                          style: pw.TextStyle(
                            fontSize: 20,
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text('🏥', style: const pw.TextStyle(fontSize: 24)),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    'تحليل خاص بـ: ${data['clinicName'] ?? 'عيادتك'}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'حالة البزنس: ${data['overall_status'] ?? 'تحليل معلق'}',
                    style: pw.TextStyle(fontSize: 14, color: PdfColors.teal),
                  ),
                  pw.Text(
                    'الدرجة الإجمالية: ${data['overall_score'] ?? 0}/100',
                    style: const pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'الملخص التنفيذي (AI):',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    data['executive_summary'] ?? 'لا يوجد ملخص متاح.',
                    style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(15),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.red.shade(50),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(10),
                      ),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Text(
                          'الفرص الضائعة شهرياً: ${data['missed_revenue'] ?? 0} ${data['currency'] ?? 'ريال'}',
                          style: pw.TextStyle(
                            color: PdfColors.red,
                            fontSize: 16,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'خسارة تقديرية بسبب ثغرات التشغيل والـ No-shows',
                          style: const pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'مؤشرات الأداء التفصيلية:',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Table(
                    border: pw.TableBorder.all(color: PdfColors.grey),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey100,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('المعيار'),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('الدرجة'),
                          ),
                        ],
                      ),
                      _buildTableRow('التسويق', '${scores['marketing'] ?? 0}%'),
                      _buildTableRow(
                        'التشغيل',
                        '${scores['operations'] ?? 0}%',
                      ),
                      _buildTableRow('المالي', '${scores['financial'] ?? 0}%'),
                      _buildTableRow(
                        'تجربة المريض',
                        '${scores['experience'] ?? 0}%',
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 30),
                  pw.Text(
                    'خطة العمل المقترحة:',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  if (data['action_steps'] is List)
                    ...(data['action_steps'] as List).map(
                      (step) => pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 10),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              '• ${step['title'] ?? ''} (${step['gain'] ?? ''})',
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            pw.Text(
                              step['desc'] ?? '',
                              style: const pw.TextStyle(
                                fontSize: 10,
                                color: PdfColors.grey700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  pw.Spacer(),
                  pw.Divider(),
                  pw.Text(
                    '© 2025 طِبابة. جميع الحقوق محفوظة. | البيانات تقديرية لأغراض استشارية.',
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: PdfColors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      return true;
    } catch (e) {
      print("PDF Error: $e");
      return false;
    }
  }
}

pw.TableRow _buildTableRow(String label, String value) {
  return pw.TableRow(
    children: [
      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(label)),
      pw.Padding(padding: const pw.EdgeInsets.all(5), child: pw.Text(value)),
    ],
  );
}
