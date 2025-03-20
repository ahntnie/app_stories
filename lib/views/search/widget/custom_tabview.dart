import 'dart:convert';

import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/constants/colors/app_colors.dart';
import 'package:app_stories/constants/colors/app_theme.dart';
import 'package:app_stories/styles/app_font.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/view_model/mystories.vm.dart';
import 'package:app_stories/views/comic/widget/custom/items/ranked.items.widget.dart';
import 'package:app_stories/views/stories/widget/stories_card.dart';
import 'package:flutter/material.dart';

import '../../../app/app_sp.dart';
import '../../../app/app_sp_key.dart';
import '../../../models/user_model.dart';
import '../../../view_model/comic.vm.dart';
import '../../../view_model/search_stories.vm.dart';
import '../../stories/stories_view/stories.page.dart';

class CustomTabView extends StatefulWidget {
  final String title;
  final SearchSotriesViewModel viewModel;
  final ComicViewModel comicViewModel;

  CustomTabView(
      {required this.title,
      required this.viewModel,
      required this.comicViewModel});

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
          labelColor: context.primaryTextColor,
          unselectedLabelColor: context.primaryTextColor,
          indicatorColor: AppColors.watermelon100,
          isScrollable: false,
          indicatorWeight: 0.5,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildStoriesList(widget.viewModel.stories),
              _buildStoriesList(widget.viewModel.storiesIsComplete),
              _buildStoriesList(widget.viewModel.storiesIsNotComplete),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStoriesList(List<dynamic> stories) {
    return stories.isNotEmpty
        ? SingleChildScrollView(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.title, style: AppTheme.titleExtraLarge24),
              ),
              ...stories.map((story) => RankedItems(
                    comicViewModel: widget.comicViewModel,
                    data: story,
                    onTap: () {
                      widget.comicViewModel.currentUsers =
                          AppSP.get(AppSPKey.currrentUser) != null &&
                                  AppSP.get(AppSPKey.currrentUser) != ''
                              ? Users.fromJson(
                                  jsonDecode(AppSP.get(AppSPKey.currrentUser)))
                              : null;
                      if (widget.comicViewModel.currentUsers != null)
                        widget.comicViewModel.idUser =
                            widget.comicViewModel.currentUsers!.id;
                      print(
                          'Số like: ${widget.comicViewModel.currentStory.favouriteUser!.length}');
                      widget.comicViewModel.currentStory = story;
                      widget.comicViewModel.checkFavourite();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ComicDetailPage(
                                    data: story,
                                    viewModel: widget.comicViewModel,
                                  )));
                    },
                  )),
            ],
          ))
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/ic_empty.png'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Dữ liệu trống', style: AppTheme.titleLarge20),
                ),
                Text('Chưa có dữ liệu ở thời điểm hiện tại',
                    style: AppTheme.titleLarge20),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                )
              ],
            ),
          );
  }
}
