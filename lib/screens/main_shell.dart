import 'package:flutter/material.dart';

import '../widgets/milo_bottom_nav.dart';
import 'games_screen.dart';
import 'home_screen.dart';
import 'learning_path_screen.dart';
import 'progress_screen.dart';
import 'rewards_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    LearningPathScreen(),
    GamesScreen(),
    RewardsScreen(),
    ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: MiloBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
