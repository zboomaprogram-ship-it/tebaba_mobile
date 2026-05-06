import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tebaba_mobile/features/auth/splash_screen.dart';
import 'package:tebaba_mobile/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {}

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? 'https://vaycshsakmvvlnitxzzh.supabase.co',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'sb_publishable_7i5czlkdkrGM2IRmcVMycw_s96TFbMB',
  );

  runApp(const TebabaApp());
}

class TebabaApp extends StatelessWidget {
  const TebabaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tebaba',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return Directionality(textDirection: TextDirection.rtl, child: child!);
      },
      home: const SplashScreen(),
    );
  }
}
