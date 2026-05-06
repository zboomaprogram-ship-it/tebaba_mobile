import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString('user_email');
      if (email == null) return null;
      return await login(email);
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> signUp(String email, String name) async {
    try {
      final response = await _supabase
          .from('profiles')
          .insert({'email': email, 'full_name': name})
          .select()
          .single();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> login(String email) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('email', email)
          .single();
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_email');
  }
}
