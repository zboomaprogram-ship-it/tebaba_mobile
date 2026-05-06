import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tebaba_mobile/core/utils/score_calculator.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AnalysisService {
  final _supabase = Supabase.instance.client;
  final String _geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<void> saveAnalysis({
    required String clinicName,
    required Map<String, dynamic> formData,
    required Map<String, dynamic> reportData,
  }) async {
    final combinedData = {
      ...reportData,
      'clinic_name': clinicName,
      'form_data': formData,
      'created_at': DateTime.now().toIso8601String(),
    };

    // 1. Save locally as fallback
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyList = prefs.getStringList('analysis_history') ?? [];
      historyList.insert(0, jsonEncode(combinedData));
      await prefs.setStringList('analysis_history', historyList);
    } catch (e) {
      print('Error saving local history: $e');
    }

    // 2. Save to Supabase
    try {
      await _supabase.from('analysis_reports').insert([
        {
          if (_supabase.auth.currentUser != null) 'user_id': _supabase.auth.currentUser!.id,
          'report_data': combinedData,
        }
      ]);
    } catch (e) {
      print('Error saving analysis to Supabase: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAnalysisHistory() async {
    List<Map<String, dynamic>> history = [];

    // 1. Try fetching from Supabase
    try {
      final response = await _supabase
          .from('analysis_reports')
          .select()
          .order('id', ascending: false);
      
      history = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching history from Supabase: $e');
    }

    // 2. Fetch from local SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final localHistoryList = prefs.getStringList('analysis_history') ?? [];
      
      final localHistory = localHistoryList.map((item) {
        final data = jsonDecode(item) as Map<String, dynamic>;
        // Map local data format to match what HistoryScreen expects from Supabase
        return {
          'id': 'local_${DateTime.now().millisecondsSinceEpoch}',
          'report_data': data,
          'clinic_name': data['clinic_name'],
          'specialty': data['form_data']?['specialty'],
          'type': data['form_data']?['type'],
          'created_at': data['created_at'],
        };
      }).toList();

      // Combine and deduplicate (simplified: just add local items that don't seem to be in remote)
      // Since local items don't have Supabase IDs, we'll just show local if remote is empty
      // or we can just combine them. For now, if remote is empty, use local.
      if (history.isEmpty && localHistory.isNotEmpty) {
        history = localHistory;
      }
    } catch (e) {
      print('Error fetching local history: $e');
    }

    return history;
  }

  Future<Map<String, dynamic>> runAiAnalysis(String clinicName, Map<String, dynamic> formData) async {
    if (_geminiApiKey.isEmpty || _geminiApiKey.length < 10) {
      return runHeuristicAnalysis(clinicName, formData);
    }

    final prompt = _buildPrompt(clinicName, formData);
    
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
Analyze the provided medical business data and provide a DEEP, UNIQUE, and PROFESSIONAL analysis.
Return ONLY a JSON object in professional ARABIC.
'''
        }
      ]
    };

    for (final model in models) {
      try {
        final response = await http.post(
          Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$_geminiApiKey'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'system_instruction': systemInstruction,
            'contents': [{'parts': [{'text': prompt}]}],
            'generationConfig': {
              'temperature': 0.8,
              'topP': 0.95,
              'responseMimeType': 'application/json',
            }
          }),
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          String text = data['candidates'][0]['content']['parts'][0]['text'];
          // Handle potential markdown wrapping
          text = text.replaceAll('```json', '').replaceAll('```', '').trim();
          return jsonDecode(text);
        } else {
          print('Gemini API Error for $model: \${response.statusCode} - \${response.body}');
        }
      } catch (e) {
        print('Exception for $model: $e');
        continue;
      }
    }

    return runHeuristicAnalysis(clinicName, formData);
  }

  Map<String, dynamic> runHeuristicAnalysis(String clinicName, Map<String, dynamic> formData) {
    return ScoreCalculator.calculateHealthScore(clinicName, formData);
  }

  String _buildPrompt(String clinicName, Map<String, dynamic> formData) {
    return """
        You are 'Tebaba Expert AI', a professional Medical Business Consultant specializing in the Middle Eastern market.
        Analyze the following medical business data for '$clinicName' and provide a DEEP, UNIQUE, and PROFESSIONAL analysis.
        
        DATA:
        - Clinic Name: $clinicName
        - Type: ${formData['type']}
        - Specialty: ${formData['specialty']}
        - Monthly Revenue: ${formData['revenue']} ${formData['currency']}
        - New Patients/Month: ${formData['patients']}
        - Avg. Service Price: ${formData['price']} ${formData['currency']}
        - Number of Doctors: ${formData['doctors']}
        - No-Show Rate: ${formData['noshow']}%
        - CRM System: ${formData['crm']}
        - Response Speed: ${formData['response']}
        - Patient Retention: ${formData['retention']}%
        - Booking Method: ${formData['booking']}
        - Marketing Budget: ${formData['mktbudget']} ${formData['currency']}
        - Instagram Activity: ${formData['instagram']}
        - Main Source of Patients: ${formData['source']}
        - Primary Goal: ${formData['goal']}
        
        REQUIRED: Return a JSON object with the following fields. 
        IMPORTANT: All text must be in professional ARABIC. The analysis must be SPECIFIC to these numbers.
        
        {
          "overall_status": "Arabic Title",
          "overall_score": number,
          "scores": { "marketing": number, "operations": number, "financial": number, "team": number, "growth": number, "experience": number },
          "executive_summary": "4-5 sentence professional Arabic summary analyzing exactly how the specific metrics interact.",
          "missed_revenue": number,
          "target_revenue": number,
          "action_steps": [
            {"title": "Arabic Step 1", "desc": "Highly specific actionable directive.", "gain": "+Amount in ${formData['currency']}"},
            {"title": "Arabic Step 2", "desc": "Operational tactic.", "gain": "+Amount in ${formData['currency']}"},
            {"title": "Arabic Step 3", "desc": "Advanced strategy.", "gain": "+Amount in ${formData['currency']}"}
          ]
        }
    """;
  }
}
