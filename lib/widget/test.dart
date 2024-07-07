import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/views/stories/widget/stories_card.dart';
import 'package:flutter/material.dart';

class CustomTabView extends StatefulWidget {
  final String title;
  final List<dynamic> stories;

  CustomTabView({required this.title, required this.stories});

  @override
  _CustomTabViewState createState() => _CustomTabViewState();
}

class _CustomTabViewState extends State<CustomTabView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Hoàn Thành'),
            Tab(text: 'Đang tiến hành'),
          ],
          labelColor: Colors.red,
          unselectedLabelColor: Colors.white,
          indicatorColor: Colors.red,
          isScrollable: false,
          indicatorWeight: 0.5,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStoriesList(widget.stories),
              _buildStoriesList(widget.stories),
              _buildStoriesList(widget.stories),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoriesList(List<dynamic> stories) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                  color: AppColor.extraColor,
                  fontSize: AppFontSize.sizeLarge,
                  fontWeight: AppFontWeight.bold),
            ),
          ),
          ...stories.map((story) => StoryCard(
                data: story,
                onTap: () {
                  // viewModel.currentStory = story;
                  // viewModel.nextPostChapter();
                },
              )),
        ],
      ),
    );
  }
}
