import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final apiKey = 'AIzaSyBALcpfRhQzMln_wTGwhZtMkqjcCawP2W0';
  final model = 'gemini-1.5-flash';
  
  final systemInstruction = {
    'parts': [{'text': 'You are a helpful assistant.'}]
  };

  final contents = [
    {
      'role': 'user',
      'parts': [{'text': 'مرحباً'}]
    },
    {
      'role': 'model',
      'parts': [{'text': 'أهلاً بك! أنا مستشارك الذكي من طِبابة.'}]
    },
    {
      'role': 'user',
      'parts': [{'text': 'hello'}]
    }
  ];

  final response = await http.post(
    Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'system_instruction': systemInstruction,
      'contents': contents
    }),
  );

  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
