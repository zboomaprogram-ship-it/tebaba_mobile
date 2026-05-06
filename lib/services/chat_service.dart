import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<String> getAiResponse(String message, List<Map<String, String>> history) async {
    if (_geminiApiKey.isEmpty || _geminiApiKey.length < 10) {
      return 'خطأ: مفتاح API غير مُهيأ. يرجى التحقق من إعدادات التطبيق.';
    }

    final models = [
      'gemini-2.5-flash',
      'gemini-flash-latest',
      'gemini-2.0-flash-lite',
      'gemini-2.0-flash',
    ];

    final systemInstruction = {
      'parts': [
        {
          'text': '''
You are 'Tebaba Expert AI', a professional Medical Business Consultant specializing in the Middle Eastern market.
Answer questions about medical clinic management, marketing, operations, and growth.
Keep answers professional, highly actionable, and in ARABIC. 
Format your response clearly with line breaks when listing points.
'''
        }
      ]
    };

    for (final model in models) {
      try {
        final contents = [
          ...history.map((m) => {
                'role': m['role'] == 'user' ? 'user' : 'model',
                'parts': [
                  {'text': m['content']!}
                ]
              }),
          {
            'role': 'user',
            'parts': [
              {'text': message}
            ]
          }
        ];

        final response = await http
            .post(
          Uri.parse(
              'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'system_instruction': systemInstruction,
            'contents': contents
          }),
        )
            .timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          return data['candidates'][0]['content']['parts'][0]['text'] as String;
        } else {
          print('Gemini API Error for $model: \${response.statusCode} - \${response.body}');
        }
      } catch (e) {
        print('Exception for $model: $e');
        continue;
      }
    }
    return 'عذراً، حدث خطأ في الاتصال بالذكاء الاصطناعي. تحقق من الاتصال بالإنترنت وحاول مرة أخرى.';
  }
}
