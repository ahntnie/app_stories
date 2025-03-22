import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/comic/widget/custom/items/categories.items.widget.dart';
import 'package:app_stories/views/comic/widget/custom/items/newstories.items.widget.dart';
import 'package:app_stories/views/comic/widget/custom/rankedheader.custom.widget.dart';
import 'package:app_stories/views/comic/widget/custom/sectionheader.custom.widget.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/home.vm.dart';

class ComicPage extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final ComicViewModel viewModel;
  const ComicPage(
      {super.key, required this.homeViewModel, required this.viewModel});

  @override
  State<ComicPage> createState() => _ComicPageState();
}

class _ComicPageState extends State<ComicPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await widget.viewModel.init();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await widget.viewModel.init();
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => widget.viewModel,
        onViewModelReady: (viewModel) async {
          viewModel.viewContext = context;
          await viewModel.init();
        },
        builder: (context, viewModel, child) {
          viewModel.viewContext = context;
          return BasePage(
              isLoading: viewModel.isBusy,
              showLogo: true,
              showAppBar: true,
              showLeading: false,
              body: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onRefresh,
                //onLoading: _onLoading,
                //enablePullUp: true,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: 'Truyện mới',
                        onPressed: () {
                          widget.homeViewModel.setIndex(1);
                        },
                      ),
                      SizedBox(
                        height: 200,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: viewModel.storiesNew.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return NewStoriesItems(
                                data: viewModel.storiesNew[index],
                                onTap: () {
                                  viewModel.currentStory =
                                      viewModel.storiesNew[index];
                                  viewModel.viewContext = context;
                                  viewModel.nextDetailStory();
                                },
                              );
                            }),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            viewModel.isCategoriesVisible =
                                !viewModel.isCategoriesVisible;
                          });
                        },
                        child: SectionHeader(
                          title: 'Phân loại truyện',
                          onPressed: () {
                            widget.homeViewModel.setIndex(1);
                          },
                        ),
                      ),
                      AnimatedSize(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: viewModel.isCategoriesVisible
                              ? Container()
                              : CategoriesItems(
                                  homeViewModel: widget.homeViewModel,
                                  categories:
                                      viewModel.categories.take(6).toList(),
                                )),
                      SectionHeader(
                        title: 'BXH hot',
                        onPressed: () {
                          widget.homeViewModel.setIndex(1);
                        },
                      ),
                      RankedHeader(
                        viewModel: viewModel,
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
