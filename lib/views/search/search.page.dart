import 'package:app_stories/constants/app_color.dart';
import 'package:app_stories/models/category_model.dart';
import 'package:app_stories/models/story_model.dart';
import 'package:app_stories/utils/build_context_extension.dart';
import 'package:app_stories/view_model/comic.vm.dart';
import 'package:app_stories/views/search/widget/custom_tabview.dart';
import 'package:app_stories/widget/base_page.dart';
import 'package:app_stories/widget/search_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:stacked/stacked.dart';

import '../../view_model/home.vm.dart';
import '../../view_model/search_stories.vm.dart';
import '../../widget/loading_shimmer.dart';
import 'widget/drawer_search.dart';

class SearchPage extends StatefulWidget {
  final HomeViewModel homeViewModel;
  final ComicViewModel comicViewModel;
  final SearchSotriesViewModel viewModel;
  const SearchPage(
      {super.key,
      required this.homeViewModel,
      required this.viewModel,
      required this.comicViewModel});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
          return BasePage(
              showLeading: false,
              isLoading: viewModel.isBusy,
              drawer: DrawerSearch(
                viewModel: viewModel,
              ),
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                    icon: Icon(
                      Icons.tune,
                      color: context.primaryTextColor,
                      size: 30,
                    ),
                  ),
                ),
              ],
              appBar: SearchTextField(
                searchController: viewModel.searchController,
                onChanged: () {
                  viewModel.searchStories();
                },
              ),
              body: viewModel.stories.isNotEmpty
                  ? viewModel.isBusy
                      ? GradientLoadingWidget()
                      : SmartRefresher(
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          //onLoading: _onLoading,
                          // enablePullUp: true,
                          child: CustomTabView(
                            comicViewModel: widget.comicViewModel,
                            title: viewModel.currentCategory?.name ?? 'Tất cả',
                            viewModel: viewModel,
                          ),
                        )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/ic_empty.png'),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Dữ liệu trống',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Text(
                            'Chưa có dữ liệu ở thời điểm hiện tại',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
                          )
                        ],
                      ),
                    ));
        });
  }
}
