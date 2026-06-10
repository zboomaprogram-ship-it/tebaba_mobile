import 'package:flutter/material.dart';
import 'package:tebaba_mobile/features/home/home_screen.dart';
import 'package:tebaba_mobile/features/tools/tools_list_screen.dart';
import 'package:tebaba_mobile/features/auth/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tebaba_mobile/core/theme/app_colors.dart';
import 'package:tebaba_mobile/shared/widgets/app_background.dart';

class MainShell extends StatefulWidget {
  final Map<String, dynamic> user;

  const MainShell({super.key, required this.user});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(user: widget.user),
      const ToolsListScreen(),
      ProfileScreen(user: widget.user),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          backgroundColor: AppColors.background,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white54,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.house, size: 20),
              activeIcon: Icon(FontAwesomeIcons.houseChimney, size: 22),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.toolbox, size: 20),
              activeIcon: Icon(FontAwesomeIcons.toolbox, size: 22),
              label: 'الأدوات',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user, size: 20),
              activeIcon: Icon(FontAwesomeIcons.solidUser, size: 22),
              label: 'حسابي',
            ),
          ],
        ),
      ),
    );
  }
}
