import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  final int currentIndex;
  final Future<void> Function(int) onTabSelected;

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blueberry80,
            AppColors.watermelon80,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        currentIndex: widget.currentIndex,
        selectedItemColor: context.primaryBackgroundColor,
        unselectedItemColor: context.primaryTextColor.withOpacity(0.6),
        onTap: (index) async {
          await widget.onTabSelected(index);
        },
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.book_fill),

            icon: const Icon(CupertinoIcons.book), // iOS-style icon
            label: 'Truyện',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.search),

            icon: const Icon(CupertinoIcons.search_circle), // Tinh tế hơn
            label: 'Tìm',
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(CupertinoIcons.person_fill),
            icon: const Icon(CupertinoIcons.person), // iOS-style user icon
            label: 'Tôi',
          ),
        ],
      ),
    );
  }
}
