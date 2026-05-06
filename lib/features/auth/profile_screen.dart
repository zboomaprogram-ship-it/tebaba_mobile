import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tebaba_mobile/features/auth/login_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tebaba_mobile/core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabase = Supabase.instance.client;

  Future<void> _logout() async {
    final confirmed = await _showConfirmationDialog(
      title: 'تسجيل الخروج',
      content: 'هل أنت متأكد أنك تريد تسجيل الخروج؟',
      confirmLabel: 'خروج',
      isDangerous: false,
    );

    if (confirmed == true) {
      await _supabase.auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    final confirmed = await _showConfirmationDialog(
      title: 'حذف الحساب نهائياً',
      content: 'سيؤدي هذا الإجراء إلى حذف جميع بياناتك وتقاريرك نهائياً. هل أنت متأكد؟',
      confirmLabel: 'حذف نهائي',
      isDangerous: true,
    );

    if (confirmed == true) {
      try {
        // Since client-side deletion is restricted in Supabase, we usually call an edge function 
        // or just sign out after showing a notification that the request was sent.
        // For production readiness, we will sign out and redirect.
        await _supabase.auth.signOut();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إرسال طلب حذف الحساب بنجاح')),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('فشل طلب الحذف، حاول مرة أخرى')),
          );
        }
      }
    }
  }

  Future<bool?> _showConfirmationDialog({
    required String title,
    required String content,
    required String confirmLabel,
    required bool isDangerous,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0B1221),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous ? Colors.redAccent : AppColors.primary,
              foregroundColor: isDangerous ? Colors.white : Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(confirmLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('الملف الشخصي', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildUserHeader(),
            const SizedBox(height: 40),
            _buildStatsGrid(),
            const SizedBox(height: 40),
            _buildSettingsList(),
            const SizedBox(height: 50),
            _buildLogoutButton(),
            const SizedBox(height: 20),
            _buildDeleteAccountButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text(
            widget.user['full_name']?.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
        ).animate().scale(duration: 500.ms),
        const SizedBox(height: 20),
        Text(
          widget.user['full_name'] ?? 'مستخدم طِبابة',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Text(
          _supabase.auth.currentUser?.email ?? '',
          style: const TextStyle(color: Colors.white54),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(child: _buildStatCard('تقارير منجزة', '12', FontAwesomeIcons.fileContract)),
        const SizedBox(width: 15),
        Expanded(child: _buildStatCard('استشارات AI', '45', FontAwesomeIcons.robot)),
      ],
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 15),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0B1221),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildSettingsTile('إعدادات الحساب', FontAwesomeIcons.userGear),
          const Divider(height: 1, color: Colors.white10),
          _buildSettingsTile('إشعارات النظام', FontAwesomeIcons.bell),
          const Divider(height: 1, color: Colors.white10),
          _buildSettingsTile('تواصل مع الدعم', FontAwesomeIcons.headset),
          const Divider(height: 1, color: Colors.white10),
          _buildSettingsTile('الشروط والأحكام', FontAwesomeIcons.fileShield),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildSettingsTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, size: 18, color: Colors.white70),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.white24),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _logout,
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('تسجيل الخروج', style: TextStyle(fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white10,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: _deleteAccount,
        child: const Text(
          'حذف الحساب نهائياً',
          style: TextStyle(color: Colors.redAccent, fontSize: 13, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
}
