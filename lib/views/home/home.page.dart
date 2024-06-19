import 'package:app_stories/views/comic/comic.page.dart';
import 'package:app_stories/views/profile/profile.page.dart';
import 'package:app_stories/views/search/search.page.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';

import '../../widget/loading_shimmer.dart';
import '../../widget/nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ComicPage(),
    const SearchPage(),
    const ProfilePage(),
  ];
  Future<void> _onTabSelected(int index) async {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _pages[_currentIndex],
        ],
      ),
      bottomNavigationBar: HomeNavigationBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
