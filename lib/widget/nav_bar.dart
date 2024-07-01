import 'package:app_stories/constants/app_color.dart';
import 'package:flutter/foundation.dart';
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
    return BottomNavigationBar(
      backgroundColor: AppColor.darkPrimary,
      currentIndex: widget.currentIndex,
      fixedColor: AppColor.selectColor,
      unselectedItemColor: AppColor.extraColor,
      onTap: (index) async {
        await widget.onTabSelected(index);
      },
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book_sharp),
          label: 'Truyện tranh',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Tìm kiếm',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline_outlined),
          label: 'Tôi',
        )
      ],
    );
  }
}
