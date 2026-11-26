import 'package:flutter/material.dart';

import '../state/progress_store.dart';
import '../widgets/milo_bottom_nav.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';
import 'practice_screen.dart';
import 'profile_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    PracticeScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!ProgressStore.instance.isOnboarded) {
      return OnboardingScreen(onComplete: () => setState(() => _currentIndex = 0));
    }

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: MiloBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
