import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  final apiKey = 'AIzaSyBALcpfRhQzMln_wTGwhZtMkqjcCawP2W0';
  final model = 'gemini-2.0-flash-lite';
  
  final contents = [
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
    body: jsonEncode({'contents': contents}),
  );

  print('Status: ${response.statusCode}');
  print('Body: ${response.body}');
}
