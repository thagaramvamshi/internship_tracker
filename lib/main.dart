
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/internship_provider.dart';
import 'screens/dashboard_screen.dart';
import 'screens/applications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/internship_tips_screen.dart';
import 'widgets/app_bottom_navigation.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => InternshipProvider(),
      child: const InternshipTrackerApp(),
    ),
  );
}

class InternshipTrackerApp extends StatelessWidget {
  const InternshipTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Internship Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        cardTheme: const CardThemeData(
          elevation: 1,
          margin: EdgeInsets.zero,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState
    extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ApplicationsScreen(),
    ProfileScreen(),
    InternshipTipsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
