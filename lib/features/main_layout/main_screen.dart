import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:movies_app/features/main_layout/tabs/discover_tab.dart';
import 'package:movies_app/features/main_layout/tabs/home_tab.dart';
import 'package:movies_app/features/main_layout/tabs/profile_tab.dart';
import 'package:movies_app/features/main_layout/tabs/search_tab.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget> tabs = [HomeTab(), SearchTab(), DiscoverTab(), ProfileTab()];
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      extendBodyBehindAppBar: true,
      body: tabs[selectedTab],
      bottomNavigationBar: _buildBottomNavigationBar,
    );
  }

  void _onTap(int tappedTab) {
    setState(() {
      selectedTab = tappedTab;
    });
  }

  Widget get _buildBottomNavigationBar {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,)
            ),
            child: BottomNavigationBar(
              onTap: _onTap,
              currentIndex: selectedTab,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
